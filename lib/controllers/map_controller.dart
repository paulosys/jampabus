import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jampabus/api/api.dart';
import 'package:jampabus/components/lines_bottom_sheet/lines_bottom_sheet.dart';
import 'package:jampabus/models/bus_stop_model.dart';

class GMapController extends GetxController {
  late GoogleMapController _mapsController;
  RxBool hasUserPosition = false.obs;
  RxBool busStopIsVisible = true.obs;

  RxSet<Marker> markers = <Marker>{}.obs;

   final markerKey = GlobalKey();

  void onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    await moveCameraToUserPosition();
  }

  Future<void> getAllBusStop() async {
    // BitmapDescriptor busIcon = await MarkerIcon.pictureAsset(
    //     assetPath: 'assets/images/bus.png', width: 56, height: 56);

    //BitmapDescriptor busIcon = await MarkerIcon.widgetToIcon(markerKey);

    List<BusStop> data = [];
    int attempts = 0;

    while (attempts < 3) {
      try {
        data = await Api.instance.getAllBusStop();
        markers.clear();
        markers.addAll(data
            .map((e) => Marker(
                markerId: MarkerId(e.code),
                position: LatLng(e.latitude, e.longitude),
                //icon: busIcon,
                visible: e.isVisible,
                infoWindow: InfoWindow(
                  title: _getTitle(e.code),
                  onTap: () => showModalBottomSheet(
                      context: Get.context!,
                      isScrollControlled: true,
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor: 0.9,
                          child: LinesBottomSheet(busStop: e),
                        );
                      }),
                )))
            .toSet());
        return;
      } catch (e) {
        attempts++;
        print("falhou");
      }
    }
  }

  void toogleBusStopVisilibity() =>
      busStopIsVisible.value = !busStopIsVisible.value;

  // void toogleBusStopVisibility() {
  //   Set<Marker> toggleMarkers = {};
  //   if (markers.first.visible == true) {
  //     toggleMarkers = markers
  //         .map((e) => Marker(
  //             markerId: e.markerId,
  //             position: e.position,
  //             icon: e.icon,
  //             visible: false,
  //             infoWindow: InfoWindow(
  //               title: e.infoWindow.title,
  //               onTap: () => e.infoWindow.onTap,
  //             )))
  //         .toSet();
  //     markers.clear();
  //     markers.addAll(toggleMarkers);
  //   } else {
  //     toggleMarkers = markers
  //         .map((e) => Marker(
  //             markerId: e.markerId,
  //             position: e.position,
  //             icon: e.icon,
  //             visible: true,
  //             infoWindow: InfoWindow(
  //               title: e.infoWindow.title,
  //               onTap: () => e.infoWindow.onTap,
  //             )))
  //         .toSet();
  //     markers.clear();
  //     markers.addAll(toggleMarkers);
  //   }
  // }

  Future<void> moveCameraToUserPosition() async {
    Position location = await getUserPosition();
    hasUserPosition.value = true;
    CameraPosition cam = CameraPosition(
        target: LatLng(location.latitude, location.longitude), zoom: 16);

    _mapsController.animateCamera(CameraUpdate.newCameraPosition(cam));
  }

  Future<Position> getUserPosition() async {
    await _askPermissions();
    return Geolocator.getCurrentPosition();
  }

  Future _askPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Get.dialog(AlertDialog(
        title: const Text('Sem acesso a localização'),
        content: const Text('É necessário acesso ao GPS. Por favor, ative.'),
        actions: [
          TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
                Get.back();
              },
              child: const Text('Abrir configurações'))
        ],
      ));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Get.dialog(AlertDialog(
          title: const Text('Sem acesso a localização'),
          content: const Text(
              'É permitir o acesso a sua localização para continuar.'),
          actions: [
            TextButton(
                onPressed: () async {
                  Get.back();
                  getUserPosition();
                },
                child: const Text('Tentar novamente'))
          ],
        ));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Get.dialog(AlertDialog(
        title: const Text('Sem acesso a localização'),
        content:
            const Text('É permitir o acesso a sua localização para continuar.'),
        actions: [
          TextButton(
              onPressed: () async {
                await Geolocator.openAppSettings();
                Get.back();
              },
              child: const Text('Abrir configurações'))
        ],
      ));
    }
  }

  Future<void> moveCameraToLocation(double latitude, double longitude) async {
    CameraPosition cam =
        CameraPosition(target: LatLng(latitude, longitude), zoom: 16);

    _mapsController.animateCamera(CameraUpdate.newCameraPosition(cam));
  }

  String? _getTitle(String originalString) {
    originalString = originalString.toUpperCase();
    RegExp regex = RegExp(r"[A-Z]{3}(.*?)P[0-9]");
    var match = regex.firstMatch(originalString);
    if (match != null) {
      var route = match.group(1);
      route = route!.replaceAll(RegExp(r"^[0-9]+"), "");
      return route.trimLeft();
    }
    return originalString;
  }
}
