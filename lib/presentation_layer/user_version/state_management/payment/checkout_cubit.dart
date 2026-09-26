import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:buy_verse_app/domain_layer/user/repositories/payment/checkout_repository.dart';
import 'package:buy_verse_app/data_layer/user/user_models/checkout_model.dart';
import 'package:dio/dio.dart';

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
      emit(CheckoutError(_errorMessage(error)));
    }
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstKey = errors.keys.first;
          final value = errors[firstKey];
          return '$firstKey: ${value is List ? value.first : value}';
        }
        if (data['message'] != null) return data['message'].toString();
      }
      return error.error?.toString() ?? 'Unable to create order';
    }
    return error.toString();
  }
}
