import 'package:buy_verse_app/presentation_layer/admin_version/state_management/admin_models/admin_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    final List<Category> dummyCategories = [
      const Category(
        id: '1',
        name: 'Electronics',
        description: 'Gadgets and tech devices',
      ),
      const Category(
        id: '2',
        name: 'Clothing',
        description: 'Fashion and apparel',
      ),
      const Category(
        id: '3',
        name: 'Food & Beverages',
        description: 'Edibles and drinks',
      ),
    ];

    on<GetCategories>((event, emit) {
      emit(CategoryLoading());
      emit(CategoryLoaded(List.from(dummyCategories)));
    });

    on<AddCategory>((event, emit) {
      if (state is CategoryLoaded) {
        final categories = List<Category>.from(
          (state as CategoryLoaded).categories,
        )..add(event.category);
        emit(CategoryLoaded(categories));
      }
    });

    on<EditCategory>((event, emit) {
      if (state is CategoryLoaded) {
        final categories = (state as CategoryLoaded).categories
            .map((c) => c.id == event.category.id ? event.category : c)
            .toList();
        emit(CategoryLoaded(categories));
      }
    });

    on<DeleteCategory>((event, emit) {
      if (state is CategoryLoaded) {
        final categories = (state as CategoryLoaded).categories
            .where((c) => c.id != event.id)
            .toList();
        emit(CategoryLoaded(categories));
      }
    });
  }
}
