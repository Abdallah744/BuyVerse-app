import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/user/repositories/payment/checkout_repository_impl.dart';
import '../../../../data_layer/user/user_models/checkout_model.dart';

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

  final CheckoutRepositoryImpl repository;

  Future<void> createOrder({
    required List<int> productIds,
    required List<int> quantities,
    required List<double> prices,
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
        prices: prices,
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
