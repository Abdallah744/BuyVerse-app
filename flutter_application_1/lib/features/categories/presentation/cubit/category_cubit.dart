import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/category_repository_impl.dart';
import '../../models/category_model.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  CategoryLoaded(this.categories);

  final List<CategoryModel> categories;
}

class CategoryEmpty extends CategoryState {}

class CategoryError extends CategoryState {
  CategoryError(this.message);

  final String message;
}

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this.repository) : super(CategoryInitial());

  final CategoryRepositoryImpl repository;

  Future<void> fetchCategories({String? token}) async {
    emit(CategoryLoading());

    try {
      final categories = await repository.getCategories(token: token);
      if (categories.isEmpty) {
        emit(CategoryEmpty());
      } else {
        emit(CategoryLoaded(categories));
      }
    } catch (error) {
      emit(CategoryError(error.toString()));
    }
  }
}
