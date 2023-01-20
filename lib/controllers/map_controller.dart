import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMapController extends GetxController {
  GMapController._privateConstructor();
  static final GMapController instance = GMapController._privateConstructor();

  late GoogleMapController _mapsController;
  RxBool hasUserPosition = false.obs;

  void onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    await moveCameraToUserPosition();
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
    CameraPosition cam = CameraPosition(
        target: LatLng(latitude, longitude), zoom: 16);

    _mapsController.animateCamera(CameraUpdate.newCameraPosition(cam));
  }

  Future<void> searchAddr(String addr) async {
    List<Location> locations = await locationFromAddress(addr);
    Location coords = locations.first;
    moveCameraToLocation(coords.latitude, coords.longitude);
  }
}
