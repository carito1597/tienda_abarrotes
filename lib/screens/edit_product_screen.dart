import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../utils/image_utils.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final Product product;
  final int index;

  const EditProductScreen({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );
    imagePath = widget.product.imagePath;
  }

  Future<void> pickImage() async {
    final path = await takeAndSavePhoto();
    if (path != null) {
      setState(() => imagePath = path);
    }
  }

  void updateProduct() {
    final updated = Product(
      name: nameController.text.trim(),
      price: double.tryParse(priceController.text) ?? 0,
      quantity: int.tryParse(quantityController.text) ?? 0,
      imagePath: imagePath,
      createdAt: widget.product.createdAt,
    );

    ref.read(productListProvider.notifier).updateProduct(widget.index, updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar producto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            if (imagePath != null)
              Image.file(
                File(imagePath!),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )
            else
              const Icon(Icons.image_not_supported, size: 100),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Cambiar imagen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateProduct,
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
