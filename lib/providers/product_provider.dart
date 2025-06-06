import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';

final productListProvider =
    NotifierProvider<ProductListNotifier, List<Product>>(ProductListNotifier.new);

class ProductListNotifier extends Notifier<List<Product>> {
  late Box<Product> _box;

  @override
  List<Product> build() {
    _box = Hive.box<Product>('products');
    return _box.values.toList();
  }

  void addProduct(Product product) {
    _box.add(product);
    state = _box.values.toList();
  }

  void deleteProduct(int index) {
    _box.deleteAt(index);
    state = _box.values.toList();
  }

  void reload() {
    state = _box.values.toList();
  }
}
