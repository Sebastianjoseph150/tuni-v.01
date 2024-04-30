import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../pages/Cart/cart_page.dart';
import '../../pages/Home/home_page.dart';
import '../../pages/caterory/categories.dart';
import '../../pages/profile/profile.dart';

List<GButton> bottomNavItems = const <GButton>[
  GButton(
    icon: Icons.home,
    iconColor: Colors.grey,
    text: 'Home',
  ),
  GButton(
    icon: Icons.apps_rounded,
    iconColor: Colors.grey,
    text: 'Categories',
  ),
  // GButton(
  //   icon: Icons.favorite,
  //   iconColor: Colors.grey,
  //   text: 'Favorites',
  // ),
  GButton(
    icon: Icons.shopping_bag,
    iconColor: Colors.grey,
    text: 'Cart',
  ),
  GButton(
    icon: Icons.person,
    iconColor: Colors.grey,
    text: 'Profile',
  ),
];

List<Widget> bottomNavScreen = <Widget>[
  const HomePage(),
  const Categories(),
  const CartPage(),
  // FavoritePage(),
  ProfilePage()

];
