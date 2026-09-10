import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/admin/admin_models/category.dart';
import '../../../../domain_layer/admin/usecases/base_usecase.dart';
import '../../../../domain_layer/admin/usecases/category/category_usecases.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final AddCategoryUseCase addCategoryUseCase;
  final EditCategoryUseCase editCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoryBloc({
    required this.getCategoriesUseCase,
    required this.addCategoryUseCase,
    required this.editCategoryUseCase,
    required this.deleteCategoryUseCase,
  }) : super(CategoryInitial()) {
    on<GetCategories>((event, emit) async {
      print('DEBUG: Fetching Categories...');
      emit(CategoryLoading());
      try {
        final response = await getCategoriesUseCase(NoParams());
        print('DEBUG: Categories Response Data: ${response.data}');

        if (response.statusCode == 200 && response.data['data'] != null) {
          final List<dynamic> data = response.data['data'];
          final categories = data.map((json) {
            return Category(
              id: json['id']?.toString() ?? json['slug'] ?? '',
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
        final response = await addCategoryUseCase(
          CategoryParams(
            name: event.category.name,
            description: event.category.description,
          ),
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
        final response = await editCategoryUseCase(
          EditCategoryParams(
            id: event.category.id,
            name: event.category.name,
            description: event.category.description,
          ),
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
        final response = await deleteCategoryUseCase(event.id);

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
