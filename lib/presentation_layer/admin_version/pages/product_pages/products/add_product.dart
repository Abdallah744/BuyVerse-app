import 'package:buy_verse_app/presentation_layer/admin_version/state_management/admin_models/admin_models.dart'
    as models;
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/product/product_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

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
  String? selectedCategory;
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      appBar: defaultAppBar(context: context, title: 'Add Product'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.setWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: double.infinity,
                  height: context.setHeight(150),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(context.setWidth(15)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.grey,
                        size: context.setWidth(40),
                      ),
                      Gap(context.setHeight(10)),
                      Text(
                        'Add Product Image',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: context.setSp(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(context.setHeight(30)),
              _buildLabel(context, 'Name'),
              defaultTextFormField(
                context: context,
                controller: nameController,
                type: TextInputType.text,
                validate: (value) => value!.isEmpty ? 'Name is required' : null,
                label: 'Product Name',
              ),
              Gap(context.setHeight(20)),
              _buildLabel(context, 'Category'),
              Container(
                padding: EdgeInsets.symmetric(horizontal: context.setWidth(15)),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(context.setWidth(15)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCategory,
                    hint: const Text('Select Category'),
                    items: ['Electronics', 'Clothing', 'Food']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedCategory = value),
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
                        _buildLabel(context, 'Price'),
                        defaultTextFormField(
                          context: context,
                          controller: priceController,
                          type: TextInputType.number,
                          validate: (value) =>
                              value!.isEmpty ? 'Required' : null,
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
                        _buildLabel(context, 'Quantity'),
                        defaultTextFormField(
                          context: context,
                          controller: quantityController,
                          type: TextInputType.number,
                          validate: (value) =>
                              value!.isEmpty ? 'Required' : null,
                          label: '0',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(context.setHeight(20)),
              _buildLabel(context, 'Description'),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.setWidth(15)),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Describe your product...',
                  contentPadding: EdgeInsets.all(context.setWidth(15)),
                ),
              ),
              Gap(context.setHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Visible to customers',
                    style: TextStyle(
                      fontSize: context.setSp(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Switch(
                    value: isVisible,
                    activeThumbColor: HexColor('F5821F'),
                    onChanged: (value) => setState(() => isVisible = value),
                  ),
                ],
              ),
              Gap(context.setHeight(30)),
              defaultButton(
                context: context,
                function: () {
                  context.read<ProductBloc>().add(
                    AddProduct(
                      models.Product(
                        id: DateTime.now().toString(),
                        name: nameController.text,
                        category: selectedCategory ?? 'Uncategorized',
                        price: priceController.text,
                        quantity: quantityController.text,
                        description: descriptionController.text,
                        image:
                            'https://img.freepik.com/free-photo/shiny-black-headphones-reflect-golden-luxury-generated-by-ai_188544-23030.jpg',
                        isVisible: isVisible,
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                text: 'Add Product',
                background: HexColor('F5821F'),
              ),
            ],
          ),
        ),
      ),
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
