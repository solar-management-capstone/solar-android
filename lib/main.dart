import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/providers/filter_package_provider.dart';
import 'package:mobile_solar_mp/config/providers/user_provider.dart';
import 'package:mobile_solar_mp/config/routes/router.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/models/filter_package.dart';
import 'package:mobile_solar_mp/utils/app_theme.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  // required for async calls in `main`
  WidgetsFlutterBinding.ensureInitialized();

  // initial SharedPreferences instance
  await SharedPreferencesUtils.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<FilterPackageProvider>(
          create: (_) => FilterPackageProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Solar MP',
        theme: appTheme(),
        initialRoute: SharedPreferencesUtils.getAccessToken() != null
            ? RoutePath.navigationBarRoute
            : RoutePath.authRoute,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: ((settings) => generateRoute(settings)),
      ),
    );
  }
}
