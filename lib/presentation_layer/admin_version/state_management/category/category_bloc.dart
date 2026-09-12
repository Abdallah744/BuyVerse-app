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
        print('DEBUG: Response Status Code: ${response.statusCode}');

        if (response.statusCode == 200 && response.data != null) {
          // Check if data is directly a list or nested in 'data' key
          List<dynamic> data = [];
          if (response.data['data'] != null) {
            data = response.data['data'];
          } else if (response.data is List) {
            data = response.data;
          }

          print('DEBUG: Data items count: ${data.length}');

          final categories = data.map((json) {
            print('DEBUG: Category JSON: $json');
            // Store the original ID type (could be int or string)
            final id = json['id'] ?? json['slug'] ?? json['_id'];
            print('DEBUG: Category ID: $id (type: ${id.runtimeType})');
            return Category(
              id: id?.toString() ?? '',
              name: json['name'] ?? json['title'] ?? '',
              description: json['description'] ?? json['desc'] ?? '',
              slug: json['slug'] ?? json['name']?.toLowerCase() ?? '',
            );
          }).toList();

          print('DEBUG: Mapped categories count: ${categories.length}');
          emit(CategoryLoaded(categories));
        } else {
          print('DEBUG: No valid data found in response');
          emit(const CategoryLoaded([]));
        }
      } catch (e) {
        print('DEBUG: Error fetching categories: $e');
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
      print('DEBUG: Deleting category with slug: ${event.slug}');
      try {
        final response = await deleteCategoryUseCase(event.slug);
        print('DEBUG: Delete response status: ${response.statusCode}');
        print('DEBUG: Delete response data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 204) {
          add(GetCategories());
          emit(const CategorySuccess('Category Deleted Successfully'));
        } else {
          print('DEBUG: Delete failed with status: ${response.statusCode}');
          add(GetCategories());
          emit(CategoryError('Failed to delete category'));
        }
      } catch (e) {
        print('DEBUG: Delete error: $e');
        // Fallback: reload categories even if delete fails on server
        // to stay in sync with what the user expects.
        add(GetCategories());

        if (e is DioException) {
          emit(
            CategoryError(
              e.response?.data['message']?.toString() ??
                  e.message ??
                  'Error deleting category',
            ),
          );
        }
      }
    });
  }
}
