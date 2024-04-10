import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../../../bloc/bnb_bloc/bottom_nav_bloc.dart';
import 'bottom_nav_bar_page_refactor.dart';

class BottomNavBarPage extends StatelessWidget {
  BottomNavBarPage({super.key});

  Color backgroundColor() {
    Color color = Colors.white;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomNavBloc, BottomNavState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            body: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: bottomNavScreen.elementAt(state.tabIndex),
            ),
            bottomNavigationBar: GNav(
              activeColor: Colors.blueGrey.shade900,
              style: GnavStyle.google,
              onTabChange: (index) {
                BlocProvider.of<BottomNavBloc>(context).add(TabChangeEvent(tabIndex: index));
              },
              selectedIndex: state.tabIndex,
              gap: 10,
              tabs: bottomNavItems
            ));
      },
    );
  }
}
