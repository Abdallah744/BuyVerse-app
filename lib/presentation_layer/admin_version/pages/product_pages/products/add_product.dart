import 'dart:io';

import 'package:buy_verse_app/core_layer/admin/helpers/app_localization.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/category/category_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/product/product_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../data_layer/admin/admin_models/product.dart' as models;

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedCategoryId;
  bool isVisible = true;
  File? productImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (image != null) {
      setState(() {
        productImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, categoryState) {
        return BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductSuccess) {
              showToast(
                context: context,
                text: l10n?.translate('success') ?? state.message,
                state: ToastStates.SUCCESS,
              );
              Navigator.pop(context);
            }
            if (state is ProductError) {
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
                title: l10n?.translate('add_product') ?? 'Add Product',
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(context.setWidth(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is ProductLoading)
                        const LinearProgressIndicator(),
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          height: context.setHeight(150),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(
                              context.setWidth(15),
                            ),
                            image: productImage != null
                                ? DecorationImage(
                                    image: FileImage(productImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: productImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.grey,
                                      size: context.setWidth(40),
                                    ),
                                    Gap(context.setHeight(10)),
                                    Text(
                                      l10n?.translate('pick_image') ??
                                          'Add Product Image',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: context.setSp(14),
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      ),
                      Gap(context.setHeight(30)),
                      _buildLabel(
                        context,
                        l10n?.translate('product_name') ?? 'Name',
                      ),
                      defaultTextFormField(
                        context: context,
                        controller: nameController,
                        type: TextInputType.text,
                        validate: (value) => value!.isEmpty
                            ? l10n?.translate('name_required') ??
                                  'Name is required'
                            : null,
                        label:
                            l10n?.translate('product_name') ?? 'Product Name',
                      ),
                      Gap(context.setHeight(20)),
                      _buildLabel(
                        context,
                        l10n?.translate('category') ?? 'Category',
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.setWidth(15),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(
                            context.setWidth(15),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCategoryId,
                            hint: Text(
                              l10n?.translate('select_category') ??
                                  'Select Category',
                            ),
                            items: categoryState is CategoryLoaded
                                ? categoryState.categories
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.id,
                                          child: Text(e.name),
                                        ),
                                      )
                                      .toList()
                                : [],
                            onChanged: (value) =>
                                setState(() => selectedCategoryId = value),
                          ),
                        ),
                      ),
                      Gap(context.setHeight(20)),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(
                                  context,
                                  l10n?.translate('price') ?? 'Price',
                                ),
                                defaultTextFormField(
                                  context: context,
                                  controller: priceController,
                                  type: TextInputType.number,
                                  validate: (value) => value!.isEmpty
                                      ? l10n?.translate('price_required') ??
                                            'Required'
                                      : null,
                                  label: '0.00',
                                ),
                              ],
                            ),
                          ),
                          Gap(context.setWidth(15)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(
                                  context,
                                  l10n?.translate('quantity') ?? 'Quantity',
                                ),
                                defaultTextFormField(
                                  context: context,
                                  controller: quantityController,
                                  type: TextInputType.number,
                                  validate: (value) => value!.isEmpty
                                      ? l10n?.translate('quantity_required') ??
                                            'Required'
                                      : null,
                                  label: '0',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(context.setHeight(20)),
                      _buildLabel(
                        context,
                        l10n?.translate('description') ?? 'Description',
                      ),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              context.setWidth(15),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          hintText:
                              l10n?.translate('description_hint') ??
                              'Describe your product...',
                          contentPadding: EdgeInsets.all(context.setWidth(15)),
                        ),
                      ),
                      Gap(context.setHeight(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n?.translate('visible_to_customers') ??
                                'Visible to customers',
                            style: TextStyle(
                              fontSize: context.setSp(16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: isVisible,
                            activeThumbColor: HexColor('F5821F'),
                            onChanged: (value) =>
                                setState(() => isVisible = value),
                          ),
                        ],
                      ),
                      Gap(context.setHeight(30)),
                      defaultButton(
                        context: context,
                        function: () {
                          if (categoryState is CategoryLoaded &&
                              categoryState.categories.isEmpty) {
                            showToast(
                              context: context,
                              text:
                                  l10n?.translate('create_category_first') ??
                                  'Please create at least one category first',
                              state: ToastStates.WARNING,
                            );
                            return;
                          }

                          if (selectedCategoryId == null) {
                            showToast(
                              context: context,
                              text:
                                  l10n?.translate('category_required') ??
                                  'Please select a category',
                              state: ToastStates.WARNING,
                            );
                            return;
                          }

                          if (productImage == null) {
                            showToast(
                              context: context,
                              text:
                                  l10n?.translate('image_required') ??
                                  'Please select a product image',
                              state: ToastStates.WARNING,
                            );
                            return;
                          }

                          context.read<ProductBloc>().add(
                            AddProduct(
                              models.Product(
                                id: '',
                                name: nameController.text,
                                category: selectedCategoryId!,
                                price: priceController.text,
                                quantity: quantityController.text,
                                description: descriptionController.text,
                                image: '',
                                isVisible: isVisible,
                              ),
                              imageFile: productImage,
                            ),
                          );
                        },
                        text: l10n?.translate('add_product') ?? 'Add Product',
                        background: state is ProductLoading
                            ? const Color(0xFFFFCC99)
                            : HexColor('F5821F'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.setHeight(8)),
      child: Text(
        label,
        style: TextStyle(
          fontSize: context.setSp(16),
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
