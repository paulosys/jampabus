import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jampabus/controllers/map_controller.dart';

import '../../../controllers/location_controller.dart';

import '../../../enum/is_searching.dart';
import '../../../models/address_model.dart';
import '../controller/home_controller.dart';
import 'search_button_mode.dart';

class SearchResults extends StatefulWidget {
  final GMapController controllerMaps;
  const SearchResults({super.key, required this.controllerMaps});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late final HomeController _homeController;
  late final LocationController _locationController;

  @override
  void initState() {
    _homeController = Get.find<HomeController>();
    _locationController = Get.find<LocationController>();
    super.initState();
  }

  Widget _buildAddrCards() {
    if (_locationController.isWaitingAdd.value) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (_locationController.addrs.isEmpty) {
      return const Expanded(
          child: Center(child: Text('Nenhum resultado encontrado.')));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _locationController.addrs.length,
        itemBuilder: (context, index) {
          Address addr = _locationController.addrs[index];
          return Card(
              child: InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              _homeController.clearSearch();
              widget.controllerMaps
                  .moveCameraToLocation(addr.latitude, addr.longitude);
            },
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Endereço:'),
              subtitle: Text(addr.toString()),
            ),
          ));
        },
      ),
    );
  }

  Widget _searchModeButtons() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SearchButtonMode(
              icon: Icon(
                Icons.directions_bus,
                color: _homeController.searchingOption.value == SearchType.line
                    ? Colors.blue
                    : Colors.grey,
              ),
              label: const Text('Linha'),
              onTap: () => _homeController.changeOptionSearch(SearchType.line)),
          VerticalDivider(
            thickness: 1,
            color: Colors.grey[300],
          ),
          SearchButtonMode(
            icon: Icon(Icons.location_on,
                color:
                    _homeController.searchingOption.value == SearchType.address
                        ? Colors.green
                        : Colors.grey),
            label: const Text('Endereço'),
            onTap: () => _homeController.changeOptionSearch(SearchType.address),
          ),
          VerticalDivider(
            thickness: 1,
            color: Colors.grey[300],
          ),
          SearchButtonMode(
            icon: Icon(Icons.star,
                color:
                    _homeController.searchingOption.value == SearchType.favorite
                        ? Colors.yellow[500]
                        : Colors.grey),
            label: const Text('Favorito'),
            onTap: () =>
                _homeController.changeOptionSearch(SearchType.favorite),
          ),
        ],
      ),
    );
  }

  Future<bool> _backButtonOnPressed() async {
    if (_homeController.isSearching) {
      _homeController.clearSearch();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double paddingSearchInput = Get.statusBarHeight + 32;

    return WillPopScope(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding:
              EdgeInsets.only(top: paddingSearchInput, left: 16, right: 16),
          color: Colors.white,
          child: Obx(() => Column(
                children: [
                  _searchModeButtons(),
                  _buildAddrCards(),
                ],
              )),
        ),
        onWillPop: () => _backButtonOnPressed());
  }
}
