import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_product_catalog/core/error/failures.dart';
import 'package:my_product_catalog/domain/entities/product.dart';
import 'package:my_product_catalog/domain/repositories/product_repository.dart';
import 'package:my_product_catalog/presentation/bloc/product_bloc.dart';
import 'package:my_product_catalog/presentation/bloc/product_event.dart';
import 'package:my_product_catalog/presentation/bloc/product_state.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepository;
  late ProductBloc bloc;

  const tProduct = Product(
    id: 1,
    title: 'Test Product',
    description: 'Test Description',
    price: 100.0,
    rating: 4.5,
    stock: 10,
    brand: 'TestBrand',
    category: 'TestCategory',
    thumbnail: 'https://test.com/thumb.png',
    images: ['https://test.com/img1.png'],
  );

  setUp(() {
    mockRepository = MockProductRepository();
    bloc = ProductBloc(repository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be ProductInitial', () {
    expect(bloc.state, const ProductInitial());
  });

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoading, ProductLoaded] when GetProductsEvent succeeds',
    build: () {
      when(() => mockRepository.getProducts(limit: 20, skip: 0))
          .thenAnswer((_) async => [tProduct]);
      return bloc;
    },
    act: (bloc) => bloc.add(const GetProductsEvent()),
    expect: () => [
      const ProductLoading(),
      const ProductLoaded(products: [tProduct], hasReachedMax: true),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoading, ProductError] when GetProductsEvent fails',
    build: () {
      when(() => mockRepository.getProducts(limit: 20, skip: 0))
          .thenThrow(const ServerFailure('Server failure'));
      return bloc;
    },
    act: (bloc) => bloc.add(const GetProductsEvent()),
    expect: () => [
      const ProductLoading(),
      const ProductError('Server failure'),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'appends products when LoadMoreProductsEvent is called without replacing previous items',
    build: () {
      when(() => mockRepository.getProducts(limit: 20, skip: 1))
          .thenAnswer((_) async => [tProduct]);
      return bloc;
    },
    seed: () => const ProductLoaded(products: [tProduct], hasReachedMax: false),
    act: (bloc) => bloc.add(const LoadMoreProductsEvent()),
    expect: () => [
      const ProductLoaded(
        products: [tProduct],
        hasReachedMax: false,
        isPaginationLoading: true,
      ),
      const ProductLoaded(
        products: [tProduct, tProduct],
        hasReachedMax: true,
        isPaginationLoading: false,
      ),
    ],
  );
}
