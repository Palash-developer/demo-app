import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/controller.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FormController controller = Get.put(FormController());

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.textController.value.text),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: FileImage(controller.image.value!),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text('Task Details'),
            ],
          ),
        ),
      ),
    );
  }
}
