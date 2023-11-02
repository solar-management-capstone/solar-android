import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/features/auth/screens/auth_screen.dart';
import 'package:mobile_solar_mp/features/edit_profile/screens/edit_profile_screen.dart';
import 'package:mobile_solar_mp/features/home/screens/home_screen.dart';
import 'package:mobile_solar_mp/features/navigation_bar/navigation_bar_app.dart';
import 'package:mobile_solar_mp/features/package_product/screens/package_product_screen.dart';
import 'package:mobile_solar_mp/features/profile/screens/profile_screen.dart';
import 'package:mobile_solar_mp/features/verification/screens/verification_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(builder: (_) => const AuthScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case NavigationBarApp.routeName:
      return MaterialPageRoute(builder: (_) => const NavigationBarApp());
    case EditProfileScreen.routeName:
      return MaterialPageRoute(builder: (_) => const EditProfileScreen());
    case ProfileScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
    case VerificationScreen.routeName:
      return MaterialPageRoute(builder: (_) => const VerificationScreen());
    case PackageProductScreen.routeName:
      return MaterialPageRoute(builder: (_) => const PackageProductScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Screen does not exist!')),
        ),
      );
  }
}
