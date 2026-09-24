import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts({int limit = 20, int skip = 0}) async {
    return await remoteDataSource.getProducts(limit: limit, skip: skip);
  }

  @override
  Future<Product> getProductDetail(int id) async {
    return await remoteDataSource.getProductDetail(id);
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    return await remoteDataSource.searchProducts(query);
  }
}
