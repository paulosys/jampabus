import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../enum/is_searching.dart';
import '../controller/home_controller.dart';

class InputSearch extends StatefulWidget {
  const InputSearch({super.key});

  @override
  State<InputSearch> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
  late final HomeController _homeController;

  @override
  void initState() {
    _homeController = Get.find<HomeController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double topMargin = MediaQuery.of(context).viewPadding.top + 16;

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
        child: Obx(
          () => TextField(
              autofocus:
                  _homeController.isSearching,
              controller: _homeController.searchInputController,
              onSubmitted: (value) => _homeController.onSubmit(),
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Pesquisar...",
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 15, top: 15),
                prefixIcon: _homeController.searchingOption.value !=
                        SearchType.none
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.grey),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _homeController.searchInputController.clear();
                          _homeController.searchingOption.value =
                              SearchType.none;
                        },
                        tooltip: 'Voltar',
                      )
                    : const Icon(Icons.location_on, color: Colors.grey),
                suffixIcon: _homeController.searchInputController.text.isEmpty
                    ? const Icon(Icons.search, color: Colors.grey)
                    : IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        tooltip: 'Limpar',
                        onPressed: () {
                          setState(() {
                            _homeController.searchInputController.clear();
                          });
                        },
                      ),
              ),
              onTap: () {
                if (_homeController.searchingOption.value == SearchType.none) {
                  _homeController.searchingOption.value = SearchType.line;
                }
              }),
        ));
  }
}
