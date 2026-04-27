import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pab/features/order/data/models/cart_item_model.dart';

class CartRepository {
  final _supabase = Supabase.instance.client;

  Future<List<CartItemModel>> getCartItems() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final List<dynamic> response = await _supabase
          .from('cart_items')
          .select('*, products(*)')
          .eq('user_id', userId);

      return response
          .map((e) => CartItemModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch cart items: $e');
    }
  }

Future<void> addToCart(CartItemModel item) async {
    try {
      final String variationValue = item.variation ?? '';

      final existingQuery = _supabase
          .from('cart_items')
          .select()
          .eq('user_id', item.userId)
          .eq('product_id', item.productId)
          .eq('is_rental', item.isRental);

      final existing = await existingQuery.maybeSingle();

      if (existing != null) {
        final existingVariation = existing['variation'] as String? ?? '';
        if (existingVariation == variationValue) {
          await _supabase
              .from('cart_items')
              .update({'quantity': (existing['quantity'] as int) + item.quantity})
              .eq('id', existing['id']);
        } else {
          await _supabase.from('cart_items').insert(item.toMap());
        }
      } else {
        await _supabase.from('cart_items').insert(item.toMap());
      }
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<void> removeFromCart(String itemId) async {
    await _supabase.from('cart_items').delete().eq('id', itemId);
  }

  Future<void> removeMultipleFromCart(List<String> itemIds) async {
    for (var id in itemIds) {
      await _supabase.from('cart_items').delete().eq('id', id);
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(itemId);
    } else {
      await _supabase
          .from('cart_items')
          .update({'quantity': quantity})
          .eq('id', itemId);
    }
  }
}
