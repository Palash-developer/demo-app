import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/controllers/controller.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final FormController controller = Get.put(FormController());
  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          interactionOptions: const InteractionOptions(
              enableMultiFingerGestureRace: true,
              pinchZoomWinGestures: MultiFingerGesture.all),
          initialCenter: controller.locationData.value == null
              ? const LatLng(51.509364, -0.128928)
              : LatLng(
                  controller.locationData.value!.latitude!,
                  controller.locationData.value!.longitude!,
                ),
          initialZoom: 13,
          minZoom: 9.2,
          maxZoom: 18,
          onTap: (tapPosition, latlng) {
            setState(() {
              markers = [];
              markers.add(
                Marker(
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40.0,
                  ),
                  point: latlng,
                ),
              );
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: markers,
            // markers: [
            //   Marker(
            //     point: LatLng(51.509364, -0.128928),
            //     width: 40,
            //     height: 40,
            //     child: Icon(
            //       Icons.location_on,
            //       color: Colors.red,
            //       size: 40.0,
            //     ),
            //   ),
            // ],
          ),
          // RichAttributionWidget(
          //   attributions: [
          //     TextSourceAttribution(
          //       'OpenStreetMap contributors',
          //       onTap: () =>
          //           launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
