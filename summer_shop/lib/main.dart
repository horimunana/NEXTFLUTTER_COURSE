import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summer_shop/core/provider/shared_preferences_provider.dart';
import 'package:summer_shop/utils/app_router.dart';
import 'package:summer_shop/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        // Inject the initialized instance into the Riverpod graph
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Summer Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // routerDelegate: routes.routerDelegate,
      // routeInformationParser: routes.routeInformationParser,
      routerConfig: routes,
    );
  }
}
