import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/controller.dart';
import 'package:myapp/screens/task_details_screen.dart';
import 'package:myapp/widgets/form_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required List taskList});

  // final List<Task> taskList;

  @override
  Widget build(BuildContext context) {
    final FormController controller = Get.put(FormController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Tasks',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => const FormWidget(),
                transition: Transition.cupertino,
              );
              controller.textController.clear();
              controller.image.value = null;
              controller.mapImageUrl.value = "";
            },
            icon: const Icon(
              CupertinoIcons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.taskList.isEmpty
            ? const Center(child: Text('No Task added yet...'))
            : ListView.builder(
                itemCount: controller.taskList.length,
                itemBuilder: (ctx, index) => ListTile(
                  leading: CircleAvatar(
                      backgroundImage: controller.image.value != null
                          ? FileImage(controller.image.value!)
                          : null),
                  title: Text(
                    controller.taskList[index].toString(),
                    style: const TextStyle(color: Colors.black),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (ctx) => CupertinoActionSheet(
                          title: const Text('Delete Task'),
                          message: Text(
                              'Are you sure you want to delete ${controller.taskList[index].toString()} task?'),
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                                controller.deleteTask(index);
                              },
                              isDestructiveAction: true,
                              child: const Text('Delete'),
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () {
                    Get.to(
                      () => const TaskDetailsScreen(),
                      transition: Transition.cupertino,
                    );
                  },
                ),
              ),
      ),
    );
  }
}
