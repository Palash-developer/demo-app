import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class FormController extends GetxController {
  final textController = TextEditingController();

  // final taskList = <String>[].obs;
  RxList<String> taskList = RxList<String>([]);
  var image = Rx<File?>(null);

  var address = Rx<String>('');

  var mapImageUrl = Rx<String>('');

  void addTask() {
    if (textController.text.isEmpty) return;
    String newTask = textController.text;
    taskList.add(newTask);
    // textController.clear();
    // taskList.refresh();
    // update();
  }

  void deleteTask(index) {
    taskList.removeAt(index);
    // update();
  }

  void uploadImg() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) return;
    image.value = File(pickedImage.path);
    // textController.clear();
  }

  var locationData = Rx<LocationData?>(null);
  void getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData.value = await location.getLocation();
    getAddress();
  }

  Future<void> getAddress() async {
    if (locationData.value != null) {
      var lat = locationData.value?.latitude;
      var lng = locationData.value?.longitude;

      if (lat != null && lng != null) {
        final url = Uri.https(
          'us1.locationiq.com',
          '/v1/reverse',
          {
            'key': 'pk.55f54c51f908429d4a3f3a2de65eb811',
            'lat': lat.toString(),
            'lon': lng.toString(),
            'format': 'json'
          },
        );

        try {
          final response = await http.get(url);

          if (response.statusCode == 200) {
            final resData = json.decode(response.body);
            address.value = resData["display_name"];
            print(address);
            // Construct the map image URL
            final mapUrl = Uri.https(
              'maps.locationiq.com',
              '/v3/staticmap',
              {
                'key': 'pk.55f54c51f908429d4a3f3a2de65eb811',
                'center': '$lat,$lng',
                'zoom': '16',
                'size': '600x400',
                'format': 'jpg',
                'maptype': 'streets',
                'markers': 'icon:large-red-cutout|$lat,$lng'
              },
            );

            mapImageUrl.value = mapUrl.toString();
            print('Map image URL: ${mapImageUrl.value}');
          } else {
            print('Failed to load address data: ${response.statusCode}');
          }
        } catch (error) {
          print('Error fetching address: $error');
        }
      } else {
        print('Latitude or longitude is null');
      }
    } else {
      print('Location data is not available');
    }
  }

  // final mapViewUrl = Uri.https(
  //         'us1.locationiq.com',
  //         '/v1/reverse',
  //         {
  //           'key': 'pk.55f54c51f908429d4a3f3a2de65eb811',
  //           'lat': 51.503126,
  //           'lon': 0.13799040,
  //           'format': 'json'
  //         },
  //       );

  Future<void> openMap() async {
    // final url = Uri.https(
    //   'us1.locationiq.com',
    //   'v1/search',
    //   {
    //     'key': 'pk.55f54c51f908429d4a3f3a2de65eb811',
    //     'q' ""
    //     'format': 'json',
    //   },
    // );
    final url = Uri.parse(
        "us1.locationiq.com/v1/reverse?key=Your_API_Access_Token&lat=22.572730&lon=88.433975&format=json&");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        final lat = resData[0]['lat'];
        final lng = resData[0]['lon'];
        print('Latitude: $lat, Longitude: $lng');
      }
    } catch (error) {
      print('Error fetching address: $error');
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
