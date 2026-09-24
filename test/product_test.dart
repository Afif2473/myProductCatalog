import 'package:flutter_test/flutter_test.dart';
import 'package:my_product_catalog/domain/entities/product.dart';

void main() {
  const tProduct1 = Product(
    id: 1,
    title: 'iPhone 15',
    description: 'Latest Apple smartphone',
    price: 999.99,
    rating: 4.8,
    stock: 50,
    brand: 'Apple',
    category: 'smartphones',
    thumbnail: 'https://dummyjson.com/thumb.jpg',
    images: ['https://dummyjson.com/img1.jpg'],
  );

  const tProduct2 = Product(
    id: 1,
    title: 'iPhone 15',
    description: 'Latest Apple smartphone',
    price: 999.99,
    rating: 4.8,
    stock: 50,
    brand: 'Apple',
    category: 'smartphones',
    thumbnail: 'https://dummyjson.com/thumb.jpg',
    images: ['https://dummyjson.com/img1.jpg'],
  );

  test('Product entity should support value equality via Equatable', () {
    expect(tProduct1, equals(tProduct2));
    // ignore: avoid_print
    print('Product entity value equality verified.');
  });
}
