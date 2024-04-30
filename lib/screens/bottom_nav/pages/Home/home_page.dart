import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tuni/screens/bottom_nav/pages/Home/platforms/andoid_home_refactor.dart';
import 'package:tuni/screens/bottom_nav/pages/Home/platforms/ios_home_refactor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    return Platform.isAndroid
        ? AndroidHome(screenWidth: screenWidth, screenHeight: screenHeight)
        : IosHome(screenWidth: screenWidth, screenHeight: screenHeight);
  }
}



