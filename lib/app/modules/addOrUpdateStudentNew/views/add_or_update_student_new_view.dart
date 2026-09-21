import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:nwc_referral/app/modules/customAppBar/custom_app_bar.dart';
import 'package:nwc_referral/common_widgets/my_drawer.dart';
import '../controllers/add_or_update_student_new_controller.dart';
import 'basic_info_screen.dart';
import 'completion_screen.dart';
import 'file_upload_screen.dart';

class AddOrUpdateStudentNewView
    extends GetView<AddOrUpdateStudentNewController> {
  AddOrUpdateStudentNewView({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(scaffoldKey: scaffoldKey,minimal: false,),
        drawer: MyDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Column(
          children: [
            Expanded(
              child: Obx(() => _getStepWidget(controller.currentStep.value)),
            ),
            //_bottomNavigation(),
          ],
        ),
      ),
    );
  }

  // Switch between different steps dynamically
  Widget _getStepWidget(int step) {
    switch (step) {
      case 0:
        return BasicInfoForm();
      case 1:
        return FileUploadSection();
      case 2:
        return CompletionSection();
      default:
        return BasicInfoForm();
    }
  }

  // Bottom Navigation (Continue / Back)
  Widget _bottomNavigation() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.currentStep.value > 0)
              ElevatedButton(
                onPressed: controller.previousStep,
                child: Text("Back"),
              ),
            ElevatedButton(
              onPressed: controller.nextStep,
              child: Text(controller.currentStep.value == 2 ? "Finish" : "Continue"),
            ),
          ],
        ),
      );
    });
  }
}
