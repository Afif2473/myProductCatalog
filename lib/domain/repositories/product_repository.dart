import '../entities/product.dart';

abstract class ProductRepository {
  /// Fetches a paginated list of products using skip and limit.
  Future<List<Product>> getProducts({int limit = 20, int skip = 0});

  /// Fetches single product detail by ID.
  Future<Product> getProductDetail(int id);

  /// Searches products matching the given query string.
  Future<List<Product>> searchProducts(String query);
}
