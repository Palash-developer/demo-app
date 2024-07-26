import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/controller.dart';
import 'package:myapp/widgets/maps.dart';

class FormWidget extends StatelessWidget {
  const FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final FormController controller = Get.put(FormController());
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: controller.textController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Obx(
                    () => controller.image.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              controller.image.value!,
                              fit: BoxFit.fill,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              controller.uploadImg();
                            },
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.camera),
                                SizedBox(width: 10),
                                Text('Add Image'),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => controller.locationData.value != null &&
                        controller.mapImageUrl.value.isNotEmpty
                    ? Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // child: Text(
                        //   "Location: ${controller.address.value}",
                        // ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            controller.mapImageUrl.value,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child:
                              Text("Location latitude: No location found..."),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.getLocation();
                      Get.to(() => const MapWidget());
                    },
                    label: const Text("Open Map"),
                    icon: const Icon(CupertinoIcons.map),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.getLocation();
                    },
                    label: const Text("Get Location"),
                    icon: const Icon(CupertinoIcons.map_pin_ellipse),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  controller.addTask();
                  Get.back();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
