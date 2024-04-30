import 'package:flutter/material.dart';

import '../../../../drawer/drawer.dart';
import '../categories_refactor.dart';
import '../pages_in_categories/category_all_page.dart';
import '../pages_in_categories/category_men_page.dart';
import '../pages_in_categories/category_women_page.dart';

class AndroidCategoryPage extends StatelessWidget {
  const AndroidCategoryPage({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text(
          'CATEGORIES',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),
        toolbarHeight: 60,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * .01),
                  categoriesItems(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      categoryName: 'All',
                      className: AllCategory(),
                      image: "Assets/category_page/unisextshirt.png",
                      color: Colors.white,
                      context: context),
                  SizedBox(height: screenHeight * .02),
                  categoriesItems(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      categoryName: 'Men',
                      className: MenCategory(),
                      image: "Assets/category_page/tshirtimage.png",
                      context: context),
                  SizedBox(height: screenHeight * .02),
                  categoriesItems(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      categoryName: 'Women',
                      className: WomenCategory(),
                      image: "Assets/category_page/womentshirt.png",
                      context: context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
