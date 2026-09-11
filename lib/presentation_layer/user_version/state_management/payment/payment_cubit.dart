import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/user/repositories/payment/payment_repository_impl.dart';
import '../../../../data_layer/user/user_models/payment_model.dart';

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

  final PaymentRepositoryImpl repository;

  Future<void> payOrder({
    required int orderId,
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
      emit(PaymentError(error.toString()));
    }
  }
}
