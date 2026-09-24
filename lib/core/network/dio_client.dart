import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class DioClient {
  final Dio dio;

  DioClient({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            )..interceptors.add(
                LogInterceptor(
                  request: true,
                  requestHeader: false,
                  requestBody: false,
                  responseHeader: false,
                  responseBody: false,
                  error: true,
                ),
              );
}
