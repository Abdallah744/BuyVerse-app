import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:buy_verse_app/domain_layer/user/repositories/products/cart_repository.dart';
import 'package:buy_verse_app/data_layer/user/user_models/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  CartLoaded(this.items);
  final List<CartModel> items;
}

class CartEmpty extends CartState {}

class CartError extends CartState {
  CartError(this.message);
  final String message;
}

class CartCubit extends Cubit<CartState> {
  CartCubit(this.repository) : super(CartInitial());

  final CartRepository repository;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchCart({String? token}) async {
    emit(CartLoading());

    try {
      final activeToken = token ?? await _getToken();
      final items = await repository.getCart(token: activeToken);
      if (items.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartLoaded(items));
      }
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }

  Future<void> addToCart({
    required int productId,
    int quantity = 1,
    String? token,
  }) async {
    try {
      final activeToken = token ?? await _getToken();
      await repository.addToCart(
        productId: productId,
        quantity: quantity,
        token: activeToken,
      );
      // Refresh cart after adding
      await fetchCart(token: activeToken);
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }

  Future<void> removeFromCart({required int productId, String? token}) async {
    try {
      final activeToken = token ?? await _getToken();
      await repository.removeFromCart(productId: productId, token: activeToken);
      // Refresh cart after removing
      await fetchCart(token: activeToken);
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }

  Future<void> updateCartItem({
    required int productId,
    required int quantity,
    String? token,
  }) async {
    try {
      final activeToken = token ?? await _getToken();
      await repository.updateCartItem(
        productId: productId,
        quantity: quantity,
        token: activeToken,
      );
      // Refresh cart after updating
      await fetchCart(token: activeToken);
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }
}
