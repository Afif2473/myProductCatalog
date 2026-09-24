import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched to load the initial list or refresh from skip: 0
class GetProductsEvent extends ProductEvent {
  const GetProductsEvent();
}

/// Dispatched when scrolling reaches near the bottom to append the next 20 items
class LoadMoreProductsEvent extends ProductEvent {
  const LoadMoreProductsEvent();
}

/// Dispatched as the user types in the search bar (debounced by 300ms)
class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Dispatched when navigating to the detail screen to fetch full product specifications
class GetProductDetailEvent extends ProductEvent {
  final int id;

  const GetProductDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}
