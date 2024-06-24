import 'package:flutter/material.dart';
import 'package:frontend/views/nursery/home.dart';
import 'package:frontend/views/nursery/my_requests.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  final String userToken;

  const NavigationMenu({Key? key, required this.userToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController(userToken: userToken));

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.list), label: 'Requests'),
          ], 
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final String userToken;
  final Rx<int> selectedIndex = 0.obs;

  late final List<Widget> screens;

  NavigationController({required this.userToken}) {
    screens = [
      HomeNursery(),
      MyRequests(),
      // MyRequests(userToken: userToken),
    ];
  }
}