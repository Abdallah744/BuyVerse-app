import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/remote/category_remote_data_source.dart';
import '../data/repositories/category_repository_impl.dart';
import '../presentation/cubit/category_cubit.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key, this.authToken});

  final String? authToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CategoryCubit(CategoryRepositoryImpl(CategoryRemoteDataSource()))
            ..fetchCategories(token: authToken),
      child: _CategoriesView(authToken: authToken),
    );
  }
}

class _CategoriesView extends StatelessWidget {
  const _CategoriesView({this.authToken});

  final String? authToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Color(0xFF1B2334),
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6047FF)),
            );
          }

          if (state is CategoryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 54,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1B2334),
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: () => context
                          .read<CategoryCubit>()
                          .fetchCategories(token: authToken),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF6047FF),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CategoryEmpty) {
            return const Center(
              child: Text(
                'No categories found',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1B2334),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          if (state is CategoryLoaded) {
            final categories = state.categories;
            return GridView.builder(
              padding: const EdgeInsets.all(18),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(22),
                          ),
                          child: category.image != null &&
                                  category.image!.isNotEmpty
                              ? Image.network(
                                  category.image!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.category_outlined,
                                    size: 52,
                                    color: Color(0xFF6047FF),
                                  ),
                                )
                              : const Icon(
                                  Icons.category_outlined,
                                  size: 52,
                                  color: Color(0xFF6047FF),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          category.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF1B2334),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Fetching categories...'));
        },
      ),
    );
  }
}
