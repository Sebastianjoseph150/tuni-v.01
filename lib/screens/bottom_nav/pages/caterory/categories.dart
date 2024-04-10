import 'package:flutter/material.dart';
import 'package:tuni/screens/bottom_nav/pages/caterory/pages_in_categories/category_all_page.dart';
import 'package:tuni/screens/bottom_nav/pages/caterory/pages_in_categories/category_kids_page.dart';
import 'package:tuni/screens/bottom_nav/pages/caterory/pages_in_categories/category_men_page.dart';
import 'package:tuni/screens/bottom_nav/pages/caterory/pages_in_categories/category_women_page.dart';

import '../../../drawer/drawer.dart';
import 'categories_refactor.dart';

class Categories extends StatelessWidget {
  Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(
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
        child: SizedBox(
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * .01),
              categoriesItems(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                categoryName: 'All',
                className: AllCategory(),
                context: context
              ),
              SizedBox(height: screenHeight * .015),
              categoriesItems(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  categoryName: 'Men',
                  className: MenCategory(),
                  context: context
              ),
              SizedBox(height: screenHeight * .015),
              categoriesItems(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  categoryName: 'Women',
                  className: WomenCategory(),
                  context: context
              ),
              SizedBox(height: screenHeight * .015),
              categoriesItems(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  categoryName: 'Kids',
                  className: KidsCategory(),
                  context: context
              ),
            ],
          ),
        ),
      ),
    );
  }
}
