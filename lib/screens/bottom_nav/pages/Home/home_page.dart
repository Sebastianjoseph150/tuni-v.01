import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../drawer/drawer.dart';
import 'home_refactor.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestore =
      FirebaseFirestore.instance.collection('Clothes').snapshots();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: DrawerWidget(),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            MainPageSliverAppBar(),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              MainPageCarouselSlider(),
              SizedBox(height: 35),
              mainPageHeading('Explore'),
              MainPageGridViewProductList(firestore: firestore),
              MainPageSeeMoreTextButton(),
              SizedBox(height: 30),
              mainPageHeading('Filter by CATEGORY'),
              MainPageFilterByCategory(
                  screenWidth: screenWidth, screenHeight: screenHeight),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}

