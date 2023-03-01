import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jampabus/routes/app_routes.dart';

import '../../api/api.dart';
import '../../controllers/map_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final GMapController _controllerMaps;

  final RxString _statusText = ''.obs;

  @override
  void initState() {
    super.initState();

    _controllerMaps = Get.put(GMapController());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _changeColorSystem();
      await loadData();
    });
  }

  void _changeColorSystem() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Theme.of(context).primaryColor,
      systemNavigationBarColor: Theme.of(context).primaryColor,
    ));
  }

  Future<void> loadData() async {
    _statusText.value = 'Conectando ao servidor...';
    await Api.instance.getToken();

    _statusText.value = 'Obtendo paradas de ônibus...';
    await _controllerMaps.getAllBusStop();

    _statusText.value = 'Carregando o mapa';
    Get.offAndToNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/splash.png', width: 100, height: 100),
          const SizedBox(height: 32),
          const CircularProgressIndicator(
            color: Colors.white,
          ),
          const SizedBox(height: 32),
          Obx(() => Text(
                '$_statusText',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),
        ],
      )),
    );
  }
}
