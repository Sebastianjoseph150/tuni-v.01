import 'package:flutter/cupertino.dart';

import '../categories_refactor.dart';
import '../pages_in_categories/category_all_page.dart';
import '../pages_in_categories/category_men_page.dart';
import '../pages_in_categories/category_women_page.dart';

class IosCategoryPage extends StatelessWidget {
  const IosCategoryPage({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text("CATEGORY"),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
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
                            image:
                            "Assets/category_page/unisextshirt.png",
                            color: CupertinoColors.white,
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
          ],
        ),
      ),
    );
  }
}
