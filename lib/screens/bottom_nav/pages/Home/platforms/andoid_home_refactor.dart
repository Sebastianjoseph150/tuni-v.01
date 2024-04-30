import 'package:flutter/material.dart';

import '../../../../drawer/drawer.dart';
import '../home_refactor.dart';

class AndroidHome extends StatelessWidget {
  const AndroidHome({
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
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const MainPageSliverAppBar(),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MainPageCarouselSlider(),
              const SizedBox(height: 20),
              const ExploreItemsInHomePage(),
              const SizedBox(height: 30),
              Center(child: mainPageHeading('Filter by CATEGORY')),
              MainPageFilterByCategory(
                  screenWidth: screenWidth, screenHeight: screenHeight),
              const Divider()
            ],
          ),
        ),
      ),
    );
  }
}
