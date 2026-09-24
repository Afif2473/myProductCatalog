import 'package:flutter_test/flutter_test.dart';
import 'package:my_product_catalog/core/constants/api_constants.dart';
import 'package:my_product_catalog/core/network/dio_client.dart';

void main() {
  test('Dio client connects to DummyJSON', () async {
    final dioClient = DioClient();
    final response = await dioClient.dio.get(
      ApiConstants.products,
      queryParameters: {'limit': 1, 'skip': 0},
    );
    expect(response.statusCode, 200);
    expect(response.data['products'], isNotEmpty);
    // ignore: avoid_print
    print('Connected to DummyJSON API: ${response.data['products'][0]['title']}');
  });
}
