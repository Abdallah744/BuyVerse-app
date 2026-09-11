import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/user/repositories/payment/payment_process_repository_impl.dart';
import '../../../../data_layer/user/user_models/payment_process_model.dart';

abstract class PaymentProcessState {}

class PaymentProcessInitial extends PaymentProcessState {}

class PaymentProcessSubmitting extends PaymentProcessState {}

class PaymentProcessSuccess extends PaymentProcessState {
  PaymentProcessSuccess(this.paymentProcess);

  final PaymentProcessModel paymentProcess;
}

class PaymentProcessError extends PaymentProcessState {
  PaymentProcessError(this.message);

  final String message;
}

class PaymentProcessCubit extends Cubit<PaymentProcessState> {
  PaymentProcessCubit(this.repository) : super(PaymentProcessInitial());

  final PaymentProcessRepositoryImpl repository;

  Future<void> processPayment({
    required Map<String, dynamic> paymentPayload,
    String? token,
  }) async {
    emit(PaymentProcessSubmitting());

    try {
      final result = await repository.processPayment(
        paymentPayload: paymentPayload,
        token: token,
      );
      emit(PaymentProcessSuccess(result));
    } catch (error) {
      emit(PaymentProcessError(error.toString()));
    }
  }
}
