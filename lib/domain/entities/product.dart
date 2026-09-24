import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final int stock;
  final String? brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.stock,
    this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        rating,
        stock,
        brand,
        category,
        thumbnail,
        images,
      ];
}
