import 'package:buy_verse_app/core_layer/admin/helpers/app_localization.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/category/add_category.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/product_pages/category/edit_category.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/category/category_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../data_layer/admin/admin_models/category.dart';

class ManageCategoryPage extends StatelessWidget {
  const ManageCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: context.setWidth(20),
            color: Colors.black,
          ),
        ),
        title: Text(
          l10n?.translate('categories') ?? 'Categories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: context.setSp(20),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.setWidth(20.0)),
            child: InkWell(
              onTap: () {
                navigateTo(context, const AddCategoryPage());
              },
              child: Container(
                padding: EdgeInsets.all(context.setWidth(8)),
                decoration: BoxDecoration(
                  color: HexColor('F5821F'),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: context.setWidth(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(context.setWidth(20.0)),
                child: Column(
                  children: [
                    if (state.categories.isEmpty)
                      Center(
                        child: Text(
                          l10n?.translate('no_data') ?? 'No categories found',
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _buildCategoryItem(
                          context,
                          state.categories[index],
                        ),
                        separatorBuilder: (context, index) =>
                            Gap(context.setHeight(15)),
                        itemCount: state.categories.length,
                      ),
                  ],
                ),
              ),
            );
          } else if (state is CategoryError) {
            return Center(child: Text(state.message));
          }
          return Center(
            child: Text(l10n?.translate('no_data') ?? 'No categories found'),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category category) {
    return Container(
      padding: EdgeInsets.all(context.setWidth(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.setWidth(15)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.setWidth(10)),
            decoration: BoxDecoration(
              color: HexColor('F5821F').withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: HexColor('F5821F'), width: 1),
            ),
            child: Icon(
              Icons.local_offer_outlined,
              color: HexColor('F5821F'),
              size: context.setWidth(24),
            ),
          ),
          Gap(context.setWidth(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.setSp(16),
                  ),
                ),
                Text(
                  category.description,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: context.setSp(14),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<CategoryBloc>().add(DeleteCategory(category.id));
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
          IconButton(
            onPressed: () {
              navigateTo(context, EditCategoryPage(category: category));
            },
            icon: Icon(
              Icons.edit_outlined,
              color: Colors.grey,
              size: context.setWidth(24),
            ),
          ),
        ],
      ),
    );
  }
}
