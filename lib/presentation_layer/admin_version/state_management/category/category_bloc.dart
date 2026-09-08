import 'package:buy_verse_app/core_layer/admin/helpers/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/admin/admin_models/category.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<GetCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final response = await DioHelper.getData(url: '/admin/categories');
        if (response.statusCode == 200 && response.data['data'] != null) {
          final List<dynamic> data = response.data['data'];
          final categories = data.map((json) {
            return Category(
              id: json['slug'] ?? json['id']?.toString() ?? '',
              name: json['name'] ?? '',
              description: json['description'] ?? '',
            );
          }).toList();
          emit(CategoryLoaded(categories));
        } else {
          emit(const CategoryLoaded([]));
        }
      } catch (e) {
        emit(const CategoryLoaded([]));
      }
    });

    on<AddCategory>((event, emit) async {
      try {
        final response = await DioHelper.postData(
          url: '/admin/categories/store',
          data: {
            'name': event.category.name,
            'description': event.category.description,
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          add(GetCategories());
          emit(const CategorySuccess('Category Added Successfully'));
        }
      } catch (e) {
        if (e is DioException) {
          emit(
            CategoryError(
              e.response?.data['message']?.toString() ??
                  e.message ??
                  'Error adding category',
            ),
          );
        }
      }
    });

    on<EditCategory>((event, emit) async {
      try {
        final response = await DioHelper.putData(
          url: '/admin/categories/update/${event.category.id}',
          data: {
            'name': event.category.name,
            'description': event.category.description,
          },
        );

        if (response.statusCode == 200) {
          add(GetCategories());
          emit(const CategorySuccess('Category Updated Successfully'));
        }
      } catch (e) {
        if (e is DioException) {
          emit(
            CategoryError(
              e.response?.data['message']?.toString() ??
                  e.message ??
                  'Error adding category',
            ),
          );
        }
      }
    });

    on<DeleteCategory>((event, emit) async {
      try {
        final response = await DioHelper.deleteData(
          url: '/admin/categories/destroy/${event.id}',
        );

        if (response.statusCode == 200) {
          add(GetCategories());
          emit(const CategorySuccess('Category Deleted Successfully'));
        }
      } catch (e) {
        if (e is DioException) {
          emit(
            CategoryError(
              e.response?.data['message']?.toString() ??
                  e.message ??
                  'Error adding category',
            ),
          );
        }
      }
    });
  }
}
