import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:jampabus/models/address_model.dart';

class LocationController extends GetxController {
  final RxList<Address> addrs = <Address>[].obs;
  final RxBool isWaitingAdd = false.obs;

  Future<void> searchLocation(String text) async {
    isWaitingAdd.value = true;
    addrs.clear();

    try {
      List<Location> locations =
          await locationFromAddress(text, localeIdentifier: 'pt_BR');

      addrs.addAll(await _locationToAddress(locations));
    } catch (e) {
      addrs.clear();
      isWaitingAdd.value = false;
      return;
    }
  }

  Future<List<Address>> _locationToAddress(List locations) async {
    List<Address> mAddrs = [];

    for (Location l in locations) {
      var placemarks = await placemarkFromCoordinates(l.latitude, l.longitude,
          localeIdentifier: 'pt_BR');

      mAddrs.addAll(placemarks.map(
        (e) => Address(
            latitude: l.latitude,
            longitude: l.longitude,
            street: e.street ?? '',
            city: e.subAdministrativeArea ?? '',
            state: e.administrativeArea ?? '',
            cep: e.postalCode ?? '',
            district: e.subLocality ?? '',
            number: e.name ?? ''),
      ));
    }

    mAddrs.removeWhere((element) => element.state != 'Paraíba');

    isWaitingAdd.value = false;
    return mAddrs;
  }

  void clear() {
    addrs.clear();
    isWaitingAdd.value = false;
  }
}
