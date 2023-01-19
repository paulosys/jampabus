import 'package:get/get.dart';
import 'package:jampabus/routes/app_routes.dart';
import 'package:jampabus/screens/home/home.dart';

abstract class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
  ];
}
