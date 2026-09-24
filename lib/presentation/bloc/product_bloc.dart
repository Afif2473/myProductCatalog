import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

/// Pure Dart StreamTransformer debounce: resets timer whenever a new event arrives within duration
EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) {
    Timer? timer;
    return Stream<Event>.multi((controller) {
      events.listen(
        (event) {
          timer?.cancel();
          timer = Timer(duration, () {
            controller.add(event);
          });
        },
        onError: controller.addError,
        onDone: () {
          timer?.cancel();
          controller.close();
        },
      );
    }).asyncExpand(mapper);
  };
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  static const int _pageSize = 20;

  ProductBloc({required this.repository}) : super(const ProductInitial()) {
    on<GetProductsEvent>(_onGetProducts);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
    on<SearchProductsEvent>(
      _onSearchProducts,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<GetProductDetailEvent>(_onGetProductDetail);
  }

  Future<void> _onGetProducts(
    GetProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      final products = await repository.getProducts(limit: _pageSize, skip: 0);
      if (products.isEmpty) {
        emit(const ProductEmpty('No products available.'));
      } else {
        emit(ProductLoaded(
          products: products,
          hasReachedMax: products.length < _pageSize,
        ));
      }
    } on Failure catch (failure) {
      emit(ProductError(failure.message));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProductLoaded ||
        currentState.hasReachedMax ||
        currentState.isPaginationLoading) {
      return;
    }

    emit(currentState.copyWith(isPaginationLoading: true));

    try {
      final newProducts = await repository.getProducts(
        limit: _pageSize,
        skip: currentState.products.length,
      );

      if (newProducts.isEmpty) {
        emit(currentState.copyWith(
          isPaginationLoading: false,
          hasReachedMax: true,
        ));
      } else {
        final updatedList = List<Product>.from(currentState.products)
          ..addAll(newProducts);
        emit(currentState.copyWith(
          products: updatedList,
          isPaginationLoading: false,
          hasReachedMax: newProducts.length < _pageSize,
        ));
      }
    } on Failure catch (failure) {
      emit(currentState.copyWith(
        isPaginationLoading: false,
        detailError: failure.message,
      ));
    } catch (e) {
      emit(currentState.copyWith(
        isPaginationLoading: false,
        detailError: e.toString(),
      ));
    }
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      add(const GetProductsEvent());
      return;
    }

    emit(const ProductLoading());
    try {
      final results = await repository.searchProducts(query);
      if (results.isEmpty) {
        emit(ProductEmpty('No products found matching "$query"'));
      } else {
        emit(ProductLoaded(
          products: results,
          hasReachedMax: true,
        ));
      }
    } on Failure catch (failure) {
      emit(ProductError(failure.message));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onGetProductDetail(
    GetProductDetailEvent event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      emit(currentState.copyWith(isDetailLoading: true, detailError: null));
      try {
        final detail = await repository.getProductDetail(event.id);
        emit(currentState.copyWith(
          selectedProduct: detail,
          isDetailLoading: false,
        ));
      } on Failure catch (failure) {
        emit(currentState.copyWith(
          isDetailLoading: false,
          detailError: failure.message,
        ));
      } catch (e) {
        emit(currentState.copyWith(
          isDetailLoading: false,
          detailError: e.toString(),
        ));
      }
    }
  }
}
