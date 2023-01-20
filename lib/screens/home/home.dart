import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../components/button_bottom_sheet/button_bottom_sheet.dart';
import '../../components/draggable_bottom_sheet/draggable_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const CameraPosition _centerJP =
      CameraPosition(target: LatLng(-7.118374, -34.879611), zoom: 15);

  Widget _floatingSearch() {
    return Positioned(
        left: 8,
        right: 8,
        bottom: 72,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 64,
                margin: const EdgeInsets.only(top: 16),
                width: MediaQuery.of(Get.context!).size.width / 1.1,
                child: _ButtonSearch(),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const GoogleMap(
          initialCameraPosition: _centerJP,
          zoomControlsEnabled: false,
        ),
        _floatingSearch()
      ]),
      bottomSheet: BottomSheet(
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
                  onTap: () {}),
                ButtonBottomSheet(
                  label: 'GPS',
                  iconData: Icons.gps_fixed,
                  onTap: () {},
                ),
                ButtonBottomSheet(
                  label: 'Ocultar',
                  iconData: Icons.bus_alert,
                  onTap: () {},
                ),
              ],
            ),
          );
        },
        onClosing: () {},
      ),
    );
  }
}

class _ButtonSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
            color: Colors.grey[200],
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return const FractionallySizedBox(
                          heightFactor: 0.9,
                          child: DraggableBottomSheet(),
                        );
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text(
                        'Pesquisar',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.black,
                      )
                    ],
                  ),
                ))));
  }
}
