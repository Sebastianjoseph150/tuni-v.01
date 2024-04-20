import 'package:flutter/material.dart';
import 'package:tuni/model/brand.dart';
import 'package:tuni/model/product_model.dart';

class CategorySelect extends ChangeNotifier {
  // Filter products by maximum price
  List<Product> priceFilter(List<Product> category, int maxPrice) {
    return category
        .where((product) => double.parse(product.price) <= maxPrice)
        .toList();
  }

  // Filter products by brand name
  List<Product> nameFilter(List<Product> category, Brand brand) {
    if (brand.brandName.isEmpty || brand.brandName == "All") {
      return category;
    }
    return category
        .where((product) => product.brand == brand.brandName)
        .toList();
  }
}
