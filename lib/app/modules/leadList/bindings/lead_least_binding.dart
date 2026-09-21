import 'package:get/get.dart';

import '../controllers/lead_list_controller.dart';

class LeadListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadListController>(
      () => LeadListController(),
    );
  }
}
