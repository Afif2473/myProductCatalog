import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_product_catalog/domain/entities/product.dart';
import 'package:my_product_catalog/presentation/bloc/product_bloc.dart';
import 'package:my_product_catalog/presentation/bloc/product_event.dart';
import 'package:my_product_catalog/presentation/bloc/product_state.dart';
import 'package:my_product_catalog/presentation/pages/product_detail_page.dart';

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

void main() {
  late MockProductBloc mockProductBloc;

  const tProduct = Product(
    id: 1,
    title: 'Essence Mascara',
    description: 'A revolutionary lash mascara.',
    price: 9.99,
    rating: 4.9,
    stock: 25,
    brand: 'Essence',
    category: 'beauty',
    thumbnail: 'https://test.com/thumb.jpg',
    images: ['https://test.com/img1.jpg'],
  );

  setUp(() {
    mockProductBloc = MockProductBloc();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<ProductBloc>.value(
        value: mockProductBloc,
        child: const ProductDetailPage(initialProduct: tProduct),
      ),
    );
  }

  testWidgets('renders initial product details correctly', (tester) async {
    when(() => mockProductBloc.state).thenReturn(
      const ProductLoaded(products: [tProduct]),
    );

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Essence Mascara'), findsWidgets);
    expect(find.text('\$9.99'), findsOneWidget);
    expect(find.text('A revolutionary lash mascara.'), findsOneWidget);
    expect(find.text('4.9'), findsOneWidget);
  });
}
