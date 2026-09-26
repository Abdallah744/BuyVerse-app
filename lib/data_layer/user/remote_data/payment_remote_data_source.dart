import 'package:dio/dio.dart';

import '../../../core_layer/user/core/network/api_config.dart';
import '../user_models/payment_model.dart';

class PaymentRemoteDataSource {
  PaymentRemoteDataSource({Dio? dio, this.baseUrl = ApiConfig.baseUrl})
    : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

  Future<PaymentModel> payOrder({
    required dynamic orderId,
    required Map<String, dynamic> paymentData,
    String? token,
  }) async {
    print('Attempting to pay for order ID/Code: $orderId');
    print('Payment data: $paymentData');

    final response = await dioClient.post(
      '$baseUrl/client/orders/pay/$orderId',
      data: paymentData,
      options: Options(
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': ApiConfig.authorizationHeader(token),
          'Accept': 'application/json',
        },
      ),
    );

    print('Payment response status: ${response.statusCode}');
    print('Payment response data: ${response.data}');

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data is Map<String, dynamic>
            ? (response.data['message'] ?? 'Payment failed')
            : 'Payment failed',
      );
    }
    dynamic payload = response.data;
    if (payload is Map<String, dynamic>) {
      final nested = payload['data'] ?? payload['payment'] ?? payload['result'];
      if (nested is Map<String, dynamic>) payload = nested;
    }
    return payload is Map<String, dynamic>
        ? PaymentModel.fromJson(payload)
        : const PaymentModel(status: 'success', message: 'Payment completed');
  }
}
