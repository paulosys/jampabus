import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jampabus/enum/is_searching.dart';
import 'package:jampabus/screens/home/controller/home_controller.dart';
import 'package:jampabus/screens/home/widgets/search_results.dart';

import '../../components/button_bottom_sheet/button_bottom_sheet.dart';
import '../../controllers/map_controller.dart';
import 'widgets/input_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const CameraPosition _centerJP =
      CameraPosition(target: LatLng(-7.118374, -34.879611), zoom: 15);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GMapController _controllerMaps;
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _changeColorSystem();

    _controllerMaps = Get.find<GMapController>();
    _homeController = Get.put(HomeController());
  }

  void _changeColorSystem() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // transparent status bar
        statusBarIconBrightness: Brightness.dark, // dark icons status bar
        systemNavigationBarColor: Colors.grey[100])); // color bottom sheet
  }

  String labelButtonHideBusStop() {
    return _controllerMaps.busStopIsVisible.value ? 'Ocultar' : 'Mostrar';
  }

  Widget _bottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ButtonBottomAppBar(
              label: 'Atualizar',
              iconData: Icons.refresh,
              onTap: () => _controllerMaps.getAllBusStop()),
          ButtonBottomAppBar(
            label: 'GPS',
            iconData: Icons.gps_fixed,
            onTap: () => _controllerMaps.moveCameraToUserPosition(),
          ),
          ButtonBottomAppBar(
            label: labelButtonHideBusStop(),
            iconData: Icons.bus_alert,
            onTap: () => _controllerMaps.toogleBusStopVisilibity(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Stack(children: [
            GoogleMap(
              initialCameraPosition: HomePage._centerJP,
              onMapCreated: (controller) {
                _controllerMaps.onMapCreated(controller);
              },
              markers: _controllerMaps.busStopIsVisible.value
                  ? _controllerMaps.markers.toSet()
                  : {},
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: _controllerMaps.hasUserPosition.value,
            ),
            if (_homeController.isSearching)
              SearchResults(controllerMaps: _controllerMaps),
            const InputSearch(),
          ]),
          bottomNavigationBar:
              _homeController.searchingOption.value == SearchType.none
                  ? _bottomAppBar()
                  : null,
        ));
  }
}
