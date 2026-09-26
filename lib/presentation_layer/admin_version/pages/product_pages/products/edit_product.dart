import 'dart:io';

import 'package:buy_verse_app/core_layer/admin/helpers/app_localization.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/category/category_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/product/product_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../data_layer/admin/admin_models/product.dart' as models;

class EditProductPage extends StatefulWidget {
  final models.Product product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController quantityController;
  late final TextEditingController descriptionController;
  String? selectedCategoryId;
  late bool isVisible;
  File? newImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(text: widget.product.price);
    quantityController = TextEditingController(text: widget.product.quantity);
    descriptionController = TextEditingController(
      text: widget.product.description,
    );
    isVisible = widget.product.isVisible;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (image != null) {
      setState(() {
        newImage = File(image.path);
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
                title: l10n?.translate('edit_product') ?? 'Edit Product',
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
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: context.setHeight(150),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(
                                context.setWidth(15),
                              ),
                              image: newImage != null
                                  ? DecorationImage(
                                      image: FileImage(newImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : widget.product.image.isNotEmpty
                                  ? DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        widget.product.image,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child:
                                newImage == null && widget.product.image.isEmpty
                                ? const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
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
                                  label: 'Price',
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
                                  label: 'Quantity',
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
                          context.read<ProductBloc>().add(
                            EditProduct(
                              models.Product(
                                id: widget.product.id,
                                name: nameController.text,
                                category:
                                    selectedCategoryId ??
                                    widget.product.category,
                                price: priceController.text,
                                quantity: quantityController.text,
                                description: descriptionController.text,
                                image: widget.product.image,
                                isVisible: isVisible,
                                slug: widget.product.slug.isNotEmpty
                                    ? widget.product.slug
                                    : widget.product.id,
                              ),
                              imageFile: newImage,
                            ),
                          );
                        },
                        text: l10n?.translate('save') ?? 'Save Changes',
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
