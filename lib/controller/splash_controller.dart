import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:covidapp/view/routes/routes.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();
  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 3), () {
      if (!Get.isRegistered<StateServicesController>()) {
        Get.put(StateServicesController(), permanent: true);
      }
      Get.offNamed(Routes.dashboard);
    });
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
