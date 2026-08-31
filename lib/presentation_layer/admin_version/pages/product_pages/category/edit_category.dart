import 'package:buy_verse_app/presentation_layer/admin_version/state_management/category/category_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/admin_models/admin_models.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

class EditCategoryPage extends StatefulWidget {
  final Category category;

  const EditCategoryPage({super.key, required this.category});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late final TextEditingController nameController;
  late final TextEditingController descController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category.name);
    descController = TextEditingController(text: widget.category.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      appBar: defaultAppBar(context: context, title: 'Edit Category'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.setWidth(20.0)),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category Name',
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
                      return 'Please enter category name';
                    }
                    return null;
                  },
                  label: '',
                ),
                Gap(context.setHeight(20)),
                Text(
                  'Description (Optional)',
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
                  hint: 'Enter category description',
                ),
                Gap(context.setHeight(40)),
                defaultButton(
                  context: context,
                  function: () {
                    if (formKey.currentState!.validate()) {
                      context.read<CategoryBloc>().add(
                        EditCategory(
                          Category(
                            id: widget.category.id,
                            name: nameController.text,
                            description: descController.text,
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  text: 'Save Changes',
                  background: HexColor('F5821F'),
                  radius: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
