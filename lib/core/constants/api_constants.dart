class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  static const String products = '/products';
  static const String searchProducts = '/products/search';

  static String productDetail(int id) => '/products/$id';
}
