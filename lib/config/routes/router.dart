import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/features/auth/screens/auth_screen.dart';
import 'package:mobile_solar_mp/features/change_password/screens/change_password_screen.dart';
import 'package:mobile_solar_mp/features/chat/screens/chat_detail_screen.dart';
import 'package:mobile_solar_mp/features/chat/screens/chat_screen.dart';
import 'package:mobile_solar_mp/features/construction_contract/screens/construction_contract_screen.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/screens/construction_contract_detail_screen.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/screens/notify_payment_success_screen.dart';
import 'package:mobile_solar_mp/features/construction_contract_detail/screens/web_view_container.dart';
import 'package:mobile_solar_mp/features/edit_profile/screens/edit_profile_screen.dart';
import 'package:mobile_solar_mp/features/history_construction_contract/screens/feedback_screen.dart';
import 'package:mobile_solar_mp/features/history_construction_contract/screens/history_construction_contract.dart';
import 'package:mobile_solar_mp/features/home/screens/home_screen.dart';
import 'package:mobile_solar_mp/features/navigation_bar/navigation_bar_app.dart';
import 'package:mobile_solar_mp/features/package/screens/filter_package_screen.dart';
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
      return MaterialPageRoute(builder: (_) => NavigationBarApp());
    case EditProfileScreen.routeName:
      return MaterialPageRoute(builder: (_) => const EditProfileScreen());
    case ProfileScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
    case VerificationScreen.routeName:
      return MaterialPageRoute(builder: (_) => const VerificationScreen());
    case PackageProductScreen.routeName:
      return MaterialPageRoute(builder: (_) => const PackageProductScreen());
    case ConstructionContractScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => const ConstructionContractScreen());
    case ConstructionContractDetailScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => ConstructionContractDetailScreen());
    case HistoryConstructionContractScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => const HistoryConstructionContractScreen());
    case FilterPackageScreen.routeName:
      return MaterialPageRoute(builder: (_) => const FilterPackageScreen());
    case WebViewContainer.routeName:
      return MaterialPageRoute(builder: (_) => WebViewContainer());
    case FeedbackScreen.routeName:
      return MaterialPageRoute(builder: (_) => const FeedbackScreen());
    case ChatScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ChatScreen());
    case ChatDetailScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ChatDetailScreen());
    case ChangePasswordScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
    case NotifyPaymentSuccessScreen.routeName:
      return MaterialPageRoute(builder: (_) => NotifyPaymentSuccessScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Screen does not exist!')),
        ),
      );
  }
}
