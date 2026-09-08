import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_layer/admin/helpers/cache_helper.dart';
import '../../../../core_layer/admin/helpers/dio_helper.dart';
import '../../../../core_layer/admin/helpers/notification_helper.dart';
import '../../../../data_layer/admin/admin_models/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<GetProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final response = await DioHelper.getData(url: '/admin/products');
        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['data'];
          final products = data.map((json) {
            final product = Product(
              id: json['slug'] ?? json['id'].toString(),
              name: json['name'] ?? '',
              category: json['category']['name'] ?? '',
              price: json['price'].toString(),
              quantity: json['quantity'].toString(),
              description: json['description'] ?? '',
              image: json['image'] ?? '',
              isVisible: json['visible'] == 1,
            );

            // فحص المخزون وإرسال إشعار محلي
            _checkStockAndNotify(product);

            return product;
          }).toList();
          emit(ProductLoaded(products));
        } else {
          emit(const ProductLoaded([]));
        }
      } catch (e) {
        emit(const ProductLoaded([]));
      }
    });

    on<AddProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        FormData formData = FormData.fromMap({
          'name': event.product.name,
          'price': event.product.price,
          'quantity': event.product.quantity,
          'category_id': event.product.category,
          'visible': event.product.isVisible ? '1' : '0',
          'description': event.product.description,
        });

        if (event.imageFile != null) {
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                event.imageFile!.path,
                filename: 'product.png',
              ),
            ),
          );
        }

        final response = await DioHelper.postData(
          url: '/admin/products/store',
          data: formData,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          add(GetProducts());
          emit(const ProductSuccess('Product Added Successfully'));
        }
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    // ... باقي العمليات (Edit, Delete) تتبع نفس النمط باستخدام DioHelper
  }

  void _checkStockAndNotify(Product product) {
    int qty = int.tryParse(product.quantity) ?? 0;
    String lang = CacheHelper.getData(key: 'languageCode') ?? 'ar';

    if (qty == 0) {
      NotificationHelper.showNotification(
        title: lang == 'ar' ? 'نفذت الكمية' : 'Out of Stock',
        body: lang == 'ar'
            ? 'المنتج ${product.name} غير متوفر'
            : '${product.name} is out of stock',
        saveToFirestore: true,
      );
    } else if (qty <= 20) {
      NotificationHelper.showNotification(
        title: lang == 'ar' ? 'تنبيه مخزون' : 'Stock Warning',
        body: lang == 'ar'
            ? 'بقي $qty قطع فقط من ${product.name}'
            : 'Only $qty left of ${product.name}',
        saveToFirestore: true,
      );
    }
  }
}
