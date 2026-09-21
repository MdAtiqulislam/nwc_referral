
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/utils/utils.dart';
import 'package:nwc_referral/common_widgets/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/download_document.dart';


class FilePreviewController extends GetxController {
  // Observable variables
  var isLoading = true.obs;
  var isLocalFile = false.obs;
  var fileUrl = ''.obs; // File URL to preview
  var fileType = ''.obs; // Detected file type (e.g., pdf, jpg)
  var isDownloading = false.obs; // Track download state
  var downloadProgress = 0.0.obs; // Track download progress

  Dio dio = Dio(); // Dio instance for file downloads
  final CancelToken cancelToken = CancelToken(); // Cancel token for Dio requests
@override
  void onInit() {
    updateStatusBar();
    super.onInit();
  }

  @override
  void onClose() {
    // Cancel download if ongoing
    if (isDownloading.value) {
      cancelToken.cancel("Download cancelled by user.");
    }
    super.onClose();
  }

  /// Detect file type based on file extension
  void detectFileType() {
    if (fileUrl.isNotEmpty) {
      fileType.value = fileUrl.value.split('.').last.toLowerCase();
      print("File Type: $fileType");
    }
  }
  /// Simulate file loading process
  Future<void> loadFile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading delay
    isLoading.value = false;
  }

  /// Request Storage Permissions
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted ||
          await Permission.storage.request().isGranted) {
        return true;
      } else {
        Get.snackbar("Permission Denied", "Storage permission is required to download files.");
        return false;
      }
    } else if (Platform.isIOS) {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else {
        Get.snackbar("Permission Denied", "Storage permission is required to download files.");
        return false;
      }
    }
    return false;
  }

  /// Get the appropriate downloads directory
  Future<Directory?> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download'); // Android's Downloads directory
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory(); // iOS app directory
    }
    return null;
  }


  /// Download file to a custom folder named after the app
  /// Download file to a custom folder named after the app
  Future<void> downloadFile() async {
    if (fileUrl.isEmpty) {
      Get.snackbar("Error", "File URL is empty");
      return;
    }else{
      downloadDocument(fileUrl: fileUrl.value,fileExtension: fileType.value);
    }
  }


}
