import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_product_catalog/domain/entities/product.dart';
import 'package:my_product_catalog/presentation/bloc/product_bloc.dart';
import 'package:my_product_catalog/presentation/bloc/product_event.dart';
import 'package:my_product_catalog/presentation/bloc/product_state.dart';
import 'package:my_product_catalog/presentation/pages/product_list_page.dart';
import 'package:my_product_catalog/presentation/widgets/product_shimmer.dart';

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

void main() {
  late MockProductBloc mockProductBloc;

  setUp(() {
    mockProductBloc = MockProductBloc();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<ProductBloc>.value(
        value: mockProductBloc,
        child: const ProductListPage(),
      ),
    );
  }

  testWidgets('renders ProductShimmerList when state is ProductLoading',
      (tester) async {
    when(() => mockProductBloc.state).thenReturn(const ProductLoading());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(ProductShimmerList), findsOneWidget);
  });

  testWidgets('renders product cards when state is ProductLoaded',
      (tester) async {
    const tProduct = Product(
      id: 1,
      title: 'Essence Mascara',
      description: 'Test description',
      price: 9.99,
      rating: 4.9,
      stock: 5,
      category: 'beauty',
      thumbnail: 'https://test.com/thumb.jpg',
      images: [],
    );

    when(() => mockProductBloc.state).thenReturn(
      const ProductLoaded(products: [tProduct]),
    );

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Essence Mascara'), findsOneWidget);
    expect(find.text('\$9.99'), findsOneWidget);
  });
}
