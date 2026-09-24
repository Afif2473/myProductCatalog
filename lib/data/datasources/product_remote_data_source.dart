import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/failures.dart';
import '../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int limit = 20, int skip = 0});
  Future<ProductModel> getProductDetail(int id);
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts({int limit = 20, int skip = 0}) async {
    try {
      final response = await client.dio.get(
        ApiConstants.products,
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );

      final List<dynamic> productsJson = response.data['products'] as List<dynamic>;
      return productsJson
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NetworkFailure(e.message ?? 'Network connection failed');
      }
      throw ServerFailure(e.message ?? 'Failed to fetch products');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ProductModel> getProductDetail(int id) async {
    try {
      final response = await client.dio.get(ApiConstants.productDetail(id));
      return ProductModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NetworkFailure(e.message ?? 'Network connection failed');
      }
      throw ServerFailure(e.message ?? 'Failed to fetch product details');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await client.dio.get(
        ApiConstants.searchProducts,
        queryParameters: {'q': query},
      );

      final List<dynamic> productsJson = response.data['products'] as List<dynamic>;
      return productsJson
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NetworkFailure(e.message ?? 'Network connection failed');
      }
      throw ServerFailure(e.message ?? 'Failed to search products');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
