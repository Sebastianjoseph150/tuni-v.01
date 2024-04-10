import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuni/bloc/auth_bloc/auth_repository.dart';
import 'package:tuni/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:tuni/bloc/home_bloc/size_bloc.dart';
import 'package:tuni/bloc/personal_details_bloc/personal_detail_bloc.dart';
import 'package:tuni/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:tuni/screens/bottom_nav/bottom_navigation_bar/routes/generated_routes.dart';
import 'package:tuni/screens/splash_screen/splash_screen.dart';

import 'bloc/address_bloc/address_bloc.dart';
import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/bnb_bloc/bottom_nav_bloc.dart';
import 'bloc/cart_bloc/cart_bloc.dart';
import 'bloc/home_bloc/home_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey =
  //     "pk_test_51OEQrwSGLVjDXb6osFXjRY3jWp90Zkv51niOmlxqYDr03pxPotHQE08EeseOwFZxiZWhDjpkWkdVod3NZ3Le502f00GaXrqoGA";
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => BottomNavBloc()),
          BlocProvider(create: (context) => HomeBloc()),
          BlocProvider(create: (context) => CartBloc()),
          BlocProvider(create: (context) => AddressBloc()),
          BlocProvider(create: (context) => FavoriteBloc()),
          BlocProvider(create: (context) => PersonalDetailBloc()),
          BlocProvider(create: (context) => UserProfileBloc()),
          BlocProvider(create: (context) => SizeBloc()),
        ],
        child: MaterialApp(
          title: 'SHAK',
          theme: ThemeData(
              primaryColor: Colors.blueGrey.shade900,
              appBarTheme: const AppBarTheme(
                  titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  centerTitle: true,
                  color: Colors.white,
                  elevation: 0),
              scaffoldBackgroundColor: Colors.white),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          initialRoute: '/',
          onGenerateRoute: RouteGenerator().generateRoute,
        ),
      ),
    );
  }
}
