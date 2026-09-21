import 'package:get/get.dart';

import '../controllers/add_or_update_student_new_controller.dart';

class AddOrUpdateStudentNewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddOrUpdateStudentNewController>(
      () => AddOrUpdateStudentNewController(),
    );
  }
}
