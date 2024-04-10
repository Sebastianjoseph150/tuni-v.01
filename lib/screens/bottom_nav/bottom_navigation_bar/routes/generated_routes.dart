import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/bnb_bloc/bottom_nav_bloc.dart';
import '../pages/bottom_nav_bar_page.dart';

class RouteGenerator {
  final BottomNavBloc bottomNavBloc = BottomNavBloc();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<BottomNavBloc>.value(
                  value: bottomNavBloc,
                  child: BottomNavBarPage(),
                ));

      default:
        return _errorRoute();
    }
  }

  Route _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
