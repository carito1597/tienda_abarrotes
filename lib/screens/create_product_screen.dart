import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../utils/image_utils.dart';

class CreateProductScreen extends ConsumerWidget {
  const CreateProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(productListProvider.notifier);

    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();
    String? imagePath;

    Future<void> pickImage() async {
      final path = await takeAndSavePhoto();
      if (path != null) {
        imagePath = path;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imagen capturada')));
      }
    }

    void addProduct() {
      final name = nameController.text.trim();
      final price = double.tryParse(priceController.text) ?? 0;
      final quantity = int.tryParse(quantityController.text) ?? 0;

      if (name.isEmpty || price <= 0 || quantity <= 0) return;

      final product = Product(
        name: name,
        price: price,
        quantity: quantity,
        imagePath: imagePath,
      );

      notifier.addProduct(product);
      nameController.clear();
      priceController.clear();
      quantityController.clear();
      imagePath = null;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre')),
          const SizedBox(height: 12),
          TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Cantidad'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(onPressed: pickImage, icon: const Icon(Icons.camera_alt), label: const Text('Tomar foto')),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: addProduct, child: const Text('Agregar producto')),
            ],
          ),
        ],
      ),
    );
  }
}
