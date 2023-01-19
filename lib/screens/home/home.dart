import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const CameraPosition _centerJP =
      CameraPosition(target: LatLng(-7.118374, -34.879611), zoom: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JampaBUS'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: const Center(
        child: GoogleMap(initialCameraPosition: _centerJP),
      ),
    );
  }
}
