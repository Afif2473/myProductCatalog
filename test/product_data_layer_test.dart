import 'package:flutter_test/flutter_test.dart';
import 'package:my_product_catalog/core/network/dio_client.dart';
import 'package:my_product_catalog/data/datasources/product_remote_data_source.dart';
import 'package:my_product_catalog/data/repositories/product_repository_impl.dart';

void main() {
  late ProductRepositoryImpl repository;

  setUp(() {
    final dioClient = DioClient();
    final remoteDataSource = ProductRemoteDataSourceImpl(client: dioClient);
    repository = ProductRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  test('Endpoint 1 (List): fetches products with pagination params', () async {
    final products = await repository.getProducts(limit: 2, skip: 0);
    expect(products.length, 2);
    // ignore: avoid_print
    print('✅ [1. List API Verified] Fetched ${products.length} products: ${products.first.title}');
  });

  test('Endpoint 2 (Detail): fetches single product by ID', () async {
    final product = await repository.getProductDetail(1);
    expect(product.id, 1);
    expect(product.title, isNotEmpty);
    // ignore: avoid_print
    print('✅ [2. Detail API Verified] Fetched product ID 1: ${product.title}');
  });

  test('Endpoint 3 (Search): searches products by query string', () async {
    final products = await repository.searchProducts('phone');
    expect(products, isNotEmpty);
    // ignore: avoid_print
    print('✅ [3. Search API Verified] Search "phone" returned ${products.length} items');
  });
}
