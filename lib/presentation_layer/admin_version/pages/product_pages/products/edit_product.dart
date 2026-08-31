import 'package:buy_verse_app/presentation_layer/admin_version/state_management/admin_models/admin_models.dart'
    as models;
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/product/product_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/componants.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';

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
  String? selectedCategory;
  late bool isVisible;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(text: widget.product.price);
    quantityController = TextEditingController(text: widget.product.quantity);
    descriptionController = TextEditingController(
      text: widget.product.description,
    );
    selectedCategory = widget.product.category;
    isVisible = widget.product.isVisible;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('F7F8FA'),
      appBar: defaultAppBar(context: context, title: 'Edit Product'),
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
                    image: DecorationImage(
                      image: NetworkImage(widget.product.image),
                      fit: BoxFit.cover,
                    ),
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
                        _buildLabel(context, 'Quantity'),
                        defaultTextFormField(
                          context: context,
                          controller: quantityController,
                          type: TextInputType.number,
                          validate: (value) =>
                              value!.isEmpty ? 'Required' : null,
                          label: 'Quantity',
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
                    EditProduct(
                      models.Product(
                        id: widget.product.id,
                        name: nameController.text,
                        category: selectedCategory ?? widget.product.category,
                        price: priceController.text,
                        quantity: quantityController.text,
                        description: descriptionController.text,
                        image: widget.product.image,
                        isVisible: isVisible,
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                text: 'Save Changes',
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
