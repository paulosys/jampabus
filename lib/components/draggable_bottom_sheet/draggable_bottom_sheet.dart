import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/map_controller.dart';
import '../../models/address_model.dart';

class DraggableBottomSheet extends StatefulWidget {
  const DraggableBottomSheet({super.key});

  @override
  State<DraggableBottomSheet> createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet> {
  final _controllerGMap = Get.put(GMapController.instance);

  final _controllerSearchAddr = Get.put(LocationController.instance);

  final _debouncer = _Debouncer(milliseconds: 1000);

  final _inputController = TextEditingController();

  RxString placeholderTxt = 'Pesquisar por linha'.obs;

  void changeOptionSearch(String option) {
    switch (option) {
      case 'l': // linha
        placeholderTxt.value = 'Pesquisar por linha';
        break;
      case 'e': // endereço
        placeholderTxt.value = 'Pesquisar por endereço';
        break;
      case 'f': // favorito
        placeholderTxt.value = 'Pesquisar por favorito';
        break;
    }
  }

  void _onSubmit() {
    String text = _inputController.text;

    switch (placeholderTxt.value) {
      case 'Pesquisar por linha': // linha
        break;
      case 'Pesquisar por endereço': // endereço
        _controllerSearchAddr.searchLocation(text);
        break;
      case 'Pesquisar por favorito': // favorito
        break;
    }
  }

  Widget _optionsButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: 1,
              child: ElevatedButton(
                  onPressed: () => changeOptionSearch('l'),
                  child: const Text('Linha'))),
          const SizedBox(width: 8),
          Expanded(
              flex: 1,
              child: ElevatedButton(
                  onPressed: () => changeOptionSearch('e'),
                  child: const Text('Endereço'))),
          const SizedBox(width: 8),
          Expanded(
              flex: 1,
              child: ElevatedButton(
                  onPressed: () => changeOptionSearch('f'),
                  child: const Text('Favorito'))),
        ],
      ),
    );
  }

  Widget _dragIndicator() {
    return Container(
      height: 3,
      width: 50,
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
    );
  }

  Widget buildAddrCards() {
    if (_controllerSearchAddr.isWaitingAdd.value) {
      return const CircularProgressIndicator();
    }

    if (_controllerSearchAddr.addrs.isEmpty) {
      return const Center(child: Text('Nenhum endereço encontrado.'));
    }

    return ListView.builder(
      itemCount: _controllerSearchAddr.addrs.length,
      itemBuilder: (context, index) {
        Address addr = _controllerSearchAddr.addrs[index];
        return Card(
            child: InkWell(
          onTap: () {
            _controllerSearchAddr.addrs.clear();
            _inputController.clear();
            _controllerGMap.moveCameraToLocation(addr.latitude, addr.longitude);
            Get.back();
          },
          child: ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Endereço:'),
            subtitle: Text(addr.toString()),
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() => Column(
            children: [
              _dragIndicator(),
              TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => _onSubmit(),
                  controller: _inputController,
                  onChanged: (value) {
                    _debouncer.run(() {
                      _onSubmit();
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    border: const OutlineInputBorder(),
                    hintText: placeholderTxt.value,
                  )),
              _optionsButtons(),
              _controllerSearchAddr.isWaitingAdd.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(height: 300, child: buildAddrCards())
            ],
          )),
    );
  }
}

class _Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  _Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
