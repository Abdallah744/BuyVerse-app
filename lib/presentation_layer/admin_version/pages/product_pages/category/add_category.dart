import 'package:buy_verse_app/presentation_layer/admin_version/state_management/category/category_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../core_layer/admin/helpers/app_localization.dart';
import '../../../../../data_layer/admin/admin_models/category.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategorySuccess) {
          showToast(
            context: context,
            text: l10n?.translate('success') ?? state.message,
            state: ToastStates.SUCCESS,
          );
          Navigator.pop(context);
        }
        if (state is CategoryError) {
          showToast(
            context: context,
            text: state.message,
            state: ToastStates.ERROR,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: HexColor('F7F8FA'),
          appBar: defaultAppBar(
            context: context,
            title: l10n?.translate('add_category') ?? 'Add Category',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(context.setWidth(20.0)),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state is CategoryLoading)
                      const LinearProgressIndicator(),
                    Text(
                      l10n?.translate('category_name') ?? 'Category Name',
                      style: TextStyle(
                        fontSize: context.setSp(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(context.setHeight(10)),
                    defaultTextFormField(
                      context: context,
                      controller: nameController,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return l10n?.translate('name_required') ??
                              'Please enter category name';
                        }
                        return null;
                      },
                      label: '',
                      hint: 'e.g. Electronics',
                    ),
                    Gap(context.setHeight(20)),
                    Text(
                      '${l10n?.translate('description') ?? 'Description'} (${l10n?.translate('optional') ?? 'Optional'})',
                      style: TextStyle(
                        fontSize: context.setSp(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(context.setHeight(10)),
                    defaultTextFormField(
                      context: context,
                      controller: descController,
                      type: TextInputType.text,
                      validate: (value) {
                        return null;
                      },
                      label: '',
                      hint:
                          l10n?.translate('category_description') ??
                          'Enter category description',
                    ),
                    Gap(context.setHeight(40)),
                    defaultButton(
                      context: context,
                      function: () {
                        if (formKey.currentState!.validate()) {
                          context.read<CategoryBloc>().add(
                            AddCategory(
                              Category(
                                id: DateTime.now().toString(),
                                name: nameController.text,
                                description: descController.text,
                              ),
                            ),
                          );
                        }
                      },
                      text:
                          l10n?.translate('add_category') ?? 'Create Category',
                      background: state is CategoryLoading
                          ? const Color(0xFFFFCC99)
                          : HexColor('F5821F'),
                      radius: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
