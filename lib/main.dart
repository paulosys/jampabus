import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';

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
      title: 'JampaBUS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: const Locale('pt', 'BR'),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.home,
    );
  }
}
