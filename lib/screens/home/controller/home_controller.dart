import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/location_controller.dart';
import '../../../enum/is_searching.dart';

class HomeController extends GetxController {
  final LocationController locationController = Get.put(LocationController());

  final Rx<SearchType> searchingOption = Rx(SearchType.none);
  final TextEditingController searchInputController = TextEditingController();

  bool get isSearching => searchingOption.value != SearchType.none;

  void changeOptionSearch(SearchType searchMode) {
    locationController.clear();
    searchingOption.value = searchMode;
  }

  void onSubmit() async {
    String text = searchInputController.text.trim();
    if (text.isEmpty) return;

    switch (searchingOption.value) {
      case SearchType.line:
        break;
      case SearchType.address:
        try {
          await locationController.searchLocation(text);
        } catch (e) {
          locationController.clear();
        }
        break;
      case SearchType.favorite:
        break;
      default:
    }
  }

  void clearSearch() {
    searchInputController.clear();
    locationController.clear();
    searchingOption.value = SearchType.none;
  }
}
