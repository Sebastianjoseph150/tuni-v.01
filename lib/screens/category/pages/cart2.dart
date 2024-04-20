import 'package:flutter/material.dart';

class Cat2 extends StatelessWidget {
  const Cat2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          // Replace this with your custom item builder logic
          return Container(
            color: Colors.green,
            child: Center(
              child: Text('Item $index'),
            ),
          );
        },
      ),
    );
  }
}
