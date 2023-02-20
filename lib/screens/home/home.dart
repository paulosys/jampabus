import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jampabus/enum/is_searching.dart';

import '../../components/button_bottom_sheet/button_bottom_sheet.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/map_controller.dart';
import '../../models/address_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const CameraPosition _centerJP =
      CameraPosition(target: LatLng(-7.118374, -34.879611), zoom: 15);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GMapController _controllerMaps;
  late final LocationController _controllerSearchAddr;

  final TextEditingController _searchInputController = TextEditingController();

  final Rx<IsSearching> searchingOption = Rx(IsSearching.none);

  @override
  void initState() {
    super.initState();
    _changeColorSystem();

    _controllerMaps = Get.find<GMapController>();
    _controllerSearchAddr = LocationController();
  }

  void _changeColorSystem() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // transparent status bar
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey[100]));
  }

  void _onSubmit() async {
    String text = _searchInputController.text.trim();
    if (text.isEmpty) return;

    switch (searchingOption.value) {
      case IsSearching.line:
        break;
      case IsSearching.address:
        try {
          await _controllerSearchAddr.searchLocation(text);
        } catch (e) {
          _controllerSearchAddr.clear();
        }
        break;
      case IsSearching.favorite:
        break;
      default:
    }
  }

  Widget _containerSearch() {
    double paddingSearchInput = Get.statusBarHeight + 32;

    return WillPopScope(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding:
              EdgeInsets.only(top: paddingSearchInput, left: 16, right: 16),
          color: Colors.white,
          child: Column(
            children: [
              _optionsButtons(),
              _buildAddrCards(),
            ],
          ),
        ),
        onWillPop: () async {
          if (searchingOption.value != IsSearching.none) {
            _searchInputController.clear();
            _controllerSearchAddr.clear();
            searchingOption.value = IsSearching.none;
            return false;
          }
          return true;
        });
  }

  Widget _buildAddrCards() {
    if (_controllerSearchAddr.isWaitingAdd.value) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (_controllerSearchAddr.addrs.isEmpty) {
      return const Expanded(
          child: Center(child: Text('Nenhum resultado encontrado.')));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _controllerSearchAddr.addrs.length,
        itemBuilder: (context, index) {
          Address addr = _controllerSearchAddr.addrs[index];
          return Card(
              child: InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              _searchInputController.clear();
              _controllerSearchAddr.clear();
              _controllerMaps.moveCameraToLocation(
                  addr.latitude, addr.longitude);
              searchingOption.value = IsSearching.none;
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

  Widget _optionsButtons() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SearchButtonOption(
              icon: Icon(
                Icons.directions_bus,
                color: searchingOption.value == IsSearching.line
                    ? Colors.blue
                    : Colors.grey,
              ),
              label: const Text('Linha'),
              onTap: () => _changeOptionSearch(IsSearching.line)),
          VerticalDivider(
            thickness: 1,
            color: Colors.grey[300],
          ),
          _SearchButtonOption(
            icon: Icon(Icons.location_on,
                color: searchingOption.value == IsSearching.address
                    ? Colors.green
                    : Colors.grey),
            label: const Text('Endereço'),
            onTap: () => _changeOptionSearch(IsSearching.address),
          ),
          VerticalDivider(
            thickness: 1,
            color: Colors.grey[300],
          ),
          _SearchButtonOption(
            icon: Icon(Icons.star,
                color: searchingOption.value == IsSearching.favorite
                    ? Colors.yellow[500]
                    : Colors.grey),
            label: const Text('Favorito'),
            onTap: () => _changeOptionSearch(IsSearching.favorite),
          ),
        ],
      ),
    );
  }

  void _changeOptionSearch(IsSearching searchMode) {
    _controllerSearchAddr.clear();
    searchingOption.value = searchMode;
  }

  Widget _inputSearch() {
    double topMargin = MediaQuery.of(context).viewPadding.top + 16;
    return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(top: topMargin, left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child:TextField(
              autofocus: searchingOption.value != IsSearching.none,
              controller: _searchInputController,
              onSubmitted: (value) => _onSubmit(),
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Pesquisar...",
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 15, top: 15),
                prefixIcon: searchingOption.value != IsSearching.none
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.grey),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _searchInputController.clear();
                          searchingOption.value = IsSearching.none;
                        },
                        tooltip: 'Voltar',
                      )
                    : const Icon(Icons.location_on, color: Colors.grey),
                suffixIcon: _searchInputController.text.isEmpty
                    ? const Icon(Icons.search, color: Colors.grey)
                    : IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        tooltip: 'Limpar',
                        onPressed: () {
                          setState(() {
                            _searchInputController.clear();
                          });
                        },
                      ),
              ),
              onTap: () {
                if (searchingOption.value != IsSearching.none) return;
                searchingOption.value = IsSearching.line;
              }),
        );
  }

  Widget _bottomSheet() {
    return BottomSheet(
      enableDrag: false,
      builder: (context) {
        return SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonBottomSheet(
                  label: 'Atualizar',
                  iconData: Icons.refresh,
                  onTap: () => _controllerMaps.getAllBusStop()),
              ButtonBottomSheet(
                label: 'GPS',
                iconData: Icons.gps_fixed,
                onTap: () => _controllerMaps.moveCameraToUserPosition(),
              ),
              ButtonBottomSheet(
                label: 'Ocultar',
                iconData: Icons.bus_alert,
                onTap: () => _controllerMaps.toogleBusStopVisilibity(),
              ),
            ],
          ),
        );
      },
      onClosing: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Stack(children: [
            GoogleMap(
              initialCameraPosition: HomePage._centerJP,
              onMapCreated: (controller) =>
                  _controllerMaps.onMapCreated(controller),
              markers: _controllerMaps.busStopIsVisible.value
                  ? _controllerMaps.markers.toSet()
                  : {},
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: _controllerMaps.hasUserPosition.value,
            ),
            if (searchingOption.value != IsSearching.none) _containerSearch(),
            _inputSearch(),
          ]),
          bottomSheet:
              searchingOption.value == IsSearching.none ? _bottomSheet() : null,
        ));
  }
}

class _SearchButtonOption extends StatelessWidget {
  final Text label;
  final Icon icon;
  final Function onTap;
  const _SearchButtonOption(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(70, 56),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(),
            splashColor: Colors.blueGrey[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon, // <-- Icon
                label, // <-- Text
              ],
            ),
          ),
        ),
      ),
    );
  }
}
