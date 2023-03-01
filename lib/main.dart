import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:jampabus/theme/themes.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JampaBUS',
      themeMode: ThemeMode.system,
      theme: theme,
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF019BE3), //0xFF01456D
      ),
      locale: const Locale('pt', 'BR'),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
    );
  }
}
