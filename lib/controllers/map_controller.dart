import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jampabus/api/api.dart';
import 'package:jampabus/models/bus_stop_model.dart';

class GMapController extends GetxController {
  GMapController._privateConstructor();
  static final GMapController instance = GMapController._privateConstructor();

  late GoogleMapController _mapsController;
  RxBool hasUserPosition = false.obs;

  RxSet<Marker> markers = <Marker>{}.obs;

  void onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    await fetchAllBusStop();
    await moveCameraToUserPosition();
  }

  Future<void> fetchAllBusStop() async {
    BitmapDescriptor busIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(52, 52)), 'assets/images/bus.png');

    try {
      List<BusStop> data = await Api.instance.getAllBusStop();
      markers.clear();
      markers.addAll(data
          .map((e) => Marker(
              markerId: MarkerId(e.code),
              position: LatLng(e.latitude, e.longitude),
              icon: busIcon,
              visible: e.isVisible,
              infoWindow: InfoWindow(
                title: _getTitle(e.code),
                onTap: () => _getTitle(e.code),
              )))
          .toSet());
    } catch (e) {
      //TODO tratar exceção
      print(e);
    }
  }

  void toogleBusStopVisibility() {
    Set<Marker> toggleMarkers = {};
    if (markers.first.visible == true) {
      toggleMarkers = markers
          .map((e) => Marker(
              markerId: e.markerId,
              position: e.position,
              icon: e.icon,
              visible: false,
              infoWindow: InfoWindow(
                title: e.infoWindow.title,
                onTap: () => e.infoWindow.onTap,
              )))
          .toSet();
      markers.clear();
      markers.addAll(toggleMarkers);
    } else {
      toggleMarkers = markers
          .map((e) => Marker(
              markerId: e.markerId,
              position: e.position,
              icon: e.icon,
              visible: true,
              infoWindow: InfoWindow(
                title: e.infoWindow.title,
                onTap: () => e.infoWindow.onTap,
              )))
          .toSet();
      markers.clear();
      markers.addAll(toggleMarkers);
    }
  }

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
