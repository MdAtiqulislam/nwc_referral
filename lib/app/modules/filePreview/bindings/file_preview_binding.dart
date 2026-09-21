import 'package:get/get.dart';

import '../controllers/file_preview_controller.dart';

class FilePreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FilePreviewController>(
      () => FilePreviewController(),
    );
  }
}
