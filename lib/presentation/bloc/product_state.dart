import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductEmpty extends ProductState {
  final String message;

  const ProductEmpty([this.message = 'No products found.']);

  @override
  List<Object?> get props => [message];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;
  final bool isPaginationLoading;
  final Product? selectedProduct;
  final bool isDetailLoading;
  final String? detailError;

  const ProductLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.isPaginationLoading = false,
    this.selectedProduct,
    this.isDetailLoading = false,
    this.detailError,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    bool? isPaginationLoading,
    Product? selectedProduct,
    bool? isDetailLoading,
    String? detailError,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      isDetailLoading: isDetailLoading ?? this.isDetailLoading,
      detailError: detailError,
    );
  }

  @override
  List<Object?> get props => [
        products,
        hasReachedMax,
        isPaginationLoading,
        selectedProduct,
        isDetailLoading,
        detailError,
      ];
}
