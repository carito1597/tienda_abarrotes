import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../utils/image_utils.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);
    final notifier = ref.read(productListProvider.notifier);

    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();

    String? imagePath;

    Future<void> pickImage() async {
      final path = await takeAndSavePhoto();
      if (path != null) {
        imagePath = path;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen capturada')),
        );
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

    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar foto'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addProduct,
                  child: const Text('Agregar producto'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('No hay productos'))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (_, index) {
                        final product = products[index];
                        return ListTile(
                          leading: product.imagePath != null
                              ? Image.file(
                                  File(product.imagePath!),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(product.name),
                          subtitle: Text(
                            'Precio: \$${product.price.toStringAsFixed(2)} | Cantidad: ${product.quantity}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => notifier.deleteProduct(index),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
