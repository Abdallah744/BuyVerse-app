part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class GetProducts extends ProductEvent {}

class AddProduct extends ProductEvent {
  final Product product;
  final File? imageFile;
  const AddProduct(this.product, {this.imageFile});

  @override
  List<Object?> get props => [product, imageFile];
}

class EditProduct extends ProductEvent {
  final Product product;
  final File? imageFile;
  const EditProduct(this.product, {this.imageFile});

  @override
  List<Object?> get props => [product, imageFile];
}

class DeleteProduct extends ProductEvent {
  final String id;
  const DeleteProduct(this.id);

  @override
  List<Object> get props => [id];
}
