import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:jampabus/models/address_model.dart';

class LocationController extends GetxController {
  LocationController._privateConstructor();
  static final LocationController instance =
      LocationController._privateConstructor();

  final RxList<Address> addrs = <Address>[].obs;
  final RxBool isWaitingAdd = false.obs;

  Future<void> searchLocation(String text) async {
    isWaitingAdd.value = true;
    addrs.clear();

    try {
      List<Location> locations =
          await locationFromAddress(text, localeIdentifier: 'pt_BR');

      for (var e in locations) {
        var addr = Address(latitude: e.latitude, longitude: e.longitude);
        addrs.add(addr);
      }
      await _locationAddress();
    } catch (e) {
      addrs.clear();
      isWaitingAdd.value = false;
      return;
    }
  }

  Future<void> _locationAddress() async {
    for (var e in addrs) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          e.latitude, e.longitude,
          localeIdentifier: 'pt_BR');

      var item = placemarks.first;
      e.cep = item.postalCode ?? '';
      e.city = item.subAdministrativeArea ?? '';
      e.district = item.subLocality ?? '';
      e.number = item.name ?? '';
      e.street = item.street ?? '';
    }

    addrs.removeWhere((element) => element.city != 'João Pessoa');
    isWaitingAdd.value = false;
  }
}
