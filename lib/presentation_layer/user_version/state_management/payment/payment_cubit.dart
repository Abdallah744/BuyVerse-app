import 'package:buy_verse_app/data_layer/user/user_models/payment_model.dart';
import 'package:buy_verse_app/domain_layer/user/repositories/payment/payment_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentProcessing extends PaymentState {}

class PaymentSuccess extends PaymentState {
  PaymentSuccess(this.payment);

  final PaymentModel payment;
}

class PaymentError extends PaymentState {
  PaymentError(this.message);

  final String message;
}

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this.repository) : super(PaymentInitial());

  final PaymentRepository repository;

  Future<void> payOrder({
    required dynamic orderId,
    required Map<String, dynamic> paymentData,
    String? token,
  }) async {
    emit(PaymentProcessing());

    try {
      final payment = await repository.payOrder(
        orderId: orderId,
        paymentData: paymentData,
        token: token,
      );
      emit(PaymentSuccess(payment));
    } catch (error) {
      emit(PaymentError(_errorMessage(error)));
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
      return error.error?.toString() ?? 'Unable to complete payment';
    }
    return error.toString();
  }
}
