// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_layer/admin/helpers/cache_helper.dart';
import '../../../../core_layer/admin/helpers/notification_helper.dart';
import '../../../../data_layer/admin/admin_models/product.dart';
import '../../../../domain_layer/admin/usecases/product/product_usecases.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final AddProductUseCase addProductUseCase;
  final EditProductUseCase editProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductBloc({
    required this.getProductsUseCase,
    required this.addProductUseCase,
    required this.editProductUseCase,
    required this.deleteProductUseCase,
  }) : super(ProductInitial()) {
    on<GetProducts>((event, emit) async {
      print('DEBUG: Fetching Products...');
      final isRefresh = event.isRefresh;

      if (state is ProductLoaded && !isRefresh) {
        // Handle pagination if needed
      }

      emit(ProductLoading());
      try {
        final response = await getProductsUseCase(1); // Page 1 for now
        print('DEBUG: Products Response Data: ${response.data}');

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['data'];
          final products = data.map((json) {
            final product = Product(
              id: json['id']?.toString() ?? json['slug'] ?? '',
              name: json['name'] ?? '',
              category: json['category']['name'] ?? '',
              price: json['price'].toString(),
              quantity: json['quantity'].toString(),
              description: json['description'] ?? '',
              image:
                  json['image_url'] ??
                  json['image'] ??
                  json['picture_url'] ??
                  json['picture'] ??
                  '',
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
        print('DEBUG: Get Products Exception: $e');
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
          final imageFile = event.imageFile;
          if (imageFile != null) {
            formData.files.add(
              MapEntry(
                'image',
                await MultipartFile.fromFile(
                  imageFile.path,
                  filename: 'product.png',
                ),
              ),
            );
          }
        }

        final response = await addProductUseCase(formData);
        print('DEBUG: Add Product Response: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          add(const GetProducts());
          emit(const ProductSuccess('Product Added Successfully'));
        } else {
          emit(ProductError(_parseError(response.data)));
        }
      } catch (e) {
        print('DEBUG: Add Product Exception: $e');
        if (e is DioException) {
          emit(ProductError(_parseError(e.response?.data)));
        } else {
          emit(ProductError(e.toString()));
        }
      }
    });

    on<EditProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        FormData formData = FormData.fromMap({
          '_method': 'PUT',
          'name': event.product.name,
          'price': event.product.price,
          'quantity': event.product.quantity,
          'category_id': event.product.category,
          'visible': event.product.isVisible ? '1' : '0',
          'description': event.product.description,
        });

        if (event.imageFile != null) {
          final imageFile = event.imageFile;
          if (imageFile != null) {
            formData.files.add(
              MapEntry(
                'image',
                await MultipartFile.fromFile(
                  imageFile.path,
                  filename: 'product.png',
                ),
              ),
            );
          }
        }

        final response = await editProductUseCase(
          EditProductParams(id: event.product.id, formData: formData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          add(const GetProducts());
          emit(const ProductSuccess('Product Updated Successfully'));
        } else {
          emit(ProductError(_parseError(response.data)));
        }
      } catch (e) {
        if (e is DioException) {
          emit(ProductError(_parseError(e.response?.data)));
        } else {
          emit(ProductError(e.toString()));
        }
      }
    });

    on<DeleteProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        final response = await deleteProductUseCase(event.id);

        if (response.statusCode == 200) {
          add(const GetProducts());
          emit(const ProductSuccess('Product Deleted Successfully'));
        } else {
          emit(ProductError(_parseError(response.data)));
        }
      } catch (e) {
        if (e is DioException) {
          emit(ProductError(_parseError(e.response?.data)));
        } else {
          emit(ProductError(e.toString()));
        }
      }
    });
  }

  String _parseError(dynamic errorResponse) {
    if (errorResponse is Map) {
      if (errorResponse['errors'] != null && errorResponse['errors'] is Map) {
        var errors = errorResponse['errors'] as Map;
        if (errors.isNotEmpty) {
          var firstKey = errors.keys.first;
          var firstError = errors[firstKey];
          if (firstError is List && firstError.isNotEmpty) {
            return "$firstKey: ${firstError[0]}";
          }
          return "$firstKey: $firstError";
        }
      }
      if (errorResponse['message'] != null) {
        return errorResponse['message'].toString();
      }
    }
    return errorResponse?.toString() ?? 'Operation failed';
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
        type: 'product',
        targetId: product.id,
      );
    } else if (qty <= 20) {
      NotificationHelper.showNotification(
        title: lang == 'ar' ? 'تنبيه مخزون' : 'Stock Warning',
        body: lang == 'ar'
            ? 'بقي $qty قطع فقط من ${product.name}'
            : 'Only $qty left of ${product.name}',
        saveToFirestore: true,
        type: 'product',
        targetId: product.id,
      );
    }
  }
}
