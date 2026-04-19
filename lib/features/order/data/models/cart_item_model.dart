import '../../../home/data/models/product_model.dart';

class CartItemModel {
  final String id;
  final String userId;
  final String productId;
  final int quantity;
  final String? variation;
  final ProductModel? product;
  bool isSelected;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.variation,
    this.product,
    this.isSelected = false,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id'] ?? '',
      productId: map['product_id'] ?? '',
      quantity: map['quantity'] ?? 1,
      variation: map['variation'],
      product: map['products'] != null
          ? ProductModel.fromMap(map['products'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'variation': variation,
    };
  }

  int get totalPrice => (product?.price ?? 0) * quantity;
}
