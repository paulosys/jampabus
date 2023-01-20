import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DraggableBottomSheet extends StatefulWidget {
  const DraggableBottomSheet({super.key});

  @override
  State<DraggableBottomSheet> createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet> {
  RxString placeholderTxt = 'Pesquisar por linha'.obs;

  void changeSearchMethod(String option) {
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

  Widget _optionsButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: 1,
              child: ElevatedButton(
                  onPressed: () => changeSearchMethod('l'),
                  child: const Text('Linha'))),
          const SizedBox(width: 8),
          Expanded(
              flex: 1,
              child: ElevatedButton(
                  onPressed: () => changeSearchMethod('e'),
                  child: const Text('Endereço'))),
          const SizedBox(width: 8),
          Expanded(
              flex: 1,
              child: ElevatedButton(
                  onPressed: () => changeSearchMethod('f'),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() => Column(
            children: [
              _dragIndicator(),
              TextField(
                  textInputAction: TextInputAction.search,
                  onTap: () {},
                  onSubmitted: (value) => {},
                  //controller: _controllerInput,
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
              _optionsButtons()
            ],
          )),
    );
  }
}