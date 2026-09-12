import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buy_verse_app/domain_layer/user/repositories/payment/checkout_repository.dart';
import 'package:buy_verse_app/data_layer/user/user_models/checkout_model.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutSubmitting extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  CheckoutSuccess(this.checkout);

  final CheckoutModel checkout;
}

class CheckoutError extends CheckoutState {
  CheckoutError(this.message);

  final String message;
}

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this.repository) : super(CheckoutInitial());

  final CheckoutRepository repository;

  Future<void> createOrder({
    required List<int> productIds,
    required List<int> quantities,
    required List<int> prices,
    required String address,
    required double latitude,
    required double longitude,
    required String paymentMethod,
    String? token,
  }) async {
    emit(CheckoutSubmitting());

    try {
      final order = await repository.createOrder(
        productIds: productIds,
        quantities: quantities,
        prices: prices.map((e) => e.toDouble()).toList(),
        address: address,
        latitude: latitude,
        longitude: longitude,
        paymentMethod: paymentMethod,
        token: token,
      );
      emit(CheckoutSuccess(order));
    } catch (error) {
      emit(CheckoutError(error.toString()));
    }
  }
}
