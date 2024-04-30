import 'package:flutter/material.dart';
import 'package:tuni/screens/bottom_nav/pages/caterory/categories_refactor.dart';

class Cat3 extends StatelessWidget {
  const Cat3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Provide constraints for the GridView.builder
        constraints: const BoxConstraints.expand(),
        child: GridView.builder(
          // Provide grid dimensions and spacing
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 0.6, // Adjust this value according to your needs
          ),
          itemBuilder: (BuildContext context, int index) {
            // Replace this with your custom item builder logic
            return SizedBox(
              // Provide dimensions for each grid item
              width: MediaQuery.of(context).size.width /
                  2, // Half of the screen width
              height: 100,
              child: productView(
                'Mens t-shirt',
                '199',
                'https://fullyfilmy.in/cdn/shop/products/New-Mockups---no-hanger---TShirt-Yellow.jpg?v=1639657077',
              ),
            );
          },
        ),
      ),
    );
  }
}
