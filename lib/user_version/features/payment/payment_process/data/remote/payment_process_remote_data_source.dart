import 'package:dio/dio.dart';

import '../../../../../core/network/api_config.dart';
import '../../models/payment_process_model.dart';

class PaymentProcessRemoteDataSource {
  PaymentProcessRemoteDataSource({
    Dio? dio,
    this.baseUrl = ApiConfig.baseUrl,
  }) : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

  Future<PaymentProcessModel> processPayment({
    required Map<String, dynamic> paymentPayload,
    String? token,
  }) async {
    final response = await dioClient.post(
      '$baseUrl/client/payments/process',
      data: paymentPayload,
      options: Options(
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': ApiConfig.authorizationHeader(token),
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: 'Payment process failed',
      );
    }
    dynamic payload = response.data;
    if (payload is Map<String, dynamic>) {
      final nested = payload['data'] ?? payload['payment'] ?? payload['result'];
      if (nested is Map<String, dynamic>) payload = nested;
    }
    return payload is Map<String, dynamic>
        ? PaymentProcessModel.fromJson(payload)
        : const PaymentProcessModel(
            status: 'success',
            message: 'Payment process completed',
          );
  }
}
