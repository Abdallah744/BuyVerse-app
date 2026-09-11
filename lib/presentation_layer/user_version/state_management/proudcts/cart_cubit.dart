import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../domain_layer/user/repositories/products/cart_repository_impl.dart';
import '../../../../data_layer/user/user_models/cart_model.dart';

abstract class CartState {}

// the all states
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

// ***************************************************
class CartCubit extends Cubit<CartState> {
  CartCubit(this.repository) : super(CartInitial());

  final CartRepositoryImpl repository;

  // we have a unique token that's the way to talk with the api , and we get and save it here
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchCart({String? token}) async {
    // first thing we loading  te cart
    emit(CartLoading());

    try {
      final activeToken = token ?? await _getToken();
      // geeting the token
      final items = await repository.getCart(token: activeToken);
      // the codition of the state
      if (items.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartLoaded(items));
      }

      // in error case in getin the token
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }

  // adding to cart function
  //************************************************************* */
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
      // await fetchCart(token: activeToken);
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }

  // removing  function
  //******************************************************* */
  Future<void> removeFromCart({required int productId, String? token}) async {
    try {
      final activeToken = token ?? await _getToken();
      await repository.removeFromCart(productId: productId, token: activeToken);
      // await fetchCart(token: activeToken);
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
      // await fetchCart(token: activeToken);
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }
}
