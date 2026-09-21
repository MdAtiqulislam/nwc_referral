/*

import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../common_widgets/custom_snackbar.dart';
import '../../services/local_services.dart';


var isDownloading = false.obs;
var downloadProgress = 0.0.obs;

Future<void> downloadDocument({required String fileUrl, String? fileExtension}) async {

  if (fileUrl.isEmpty) {
    Get.snackbar("Error", "File URL is empty");
    return;
  }

  try {
    isDownloading.value = true;
    downloadProgress.value = 0.0;
    EasyLoading.show(status: 'Downloading...');

    Directory? downloadsDir = await getDownloadDirectory();
    if (downloadsDir == null) throw Exception("Download directory not accessible");

    // File name and extension
    String fileName = fileUrl.split('/').last;
    if (fileExtension != null && fileExtension.isNotEmpty) {
      // fileName += ".$fileExtension"; // already handled via URL
    } else {
      if (!fileName.endsWith(".pdf")) fileName += ".pdf";
    }

    String savePath = '${downloadsDir.path}/$fileName'.replaceAll("?", "_");

    // Token for authentication
    String? token = await LocalServices.getToken();
    if (token == null || token.isEmpty) throw Exception("Authentication token is missing.");

    // API Call
    final uri = Uri.parse(fileUrl);

    var response = await http.get(
      uri,
      headers: {
    //    "Authorization": "Bearer $token",
        "User-Agent": "Mozilla/5.0",
      },
    );

    if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
      File file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);

      isDownloading.value = false;
      EasyLoading.dismiss();

      bool? openFileDialog = await Get.dialog(
        AlertDialog(
          title: Text("Download Complete"),
          content: Text("Do you want to open the file?"),
          actions: [
            TextButton(onPressed: () => Get.back(result: false), child: Text("No")),
            TextButton(onPressed: () => Get.back(result: true), child: Text("Yes")),
          ],
        ),
      );

      if (openFileDialog == true) OpenFilex.open(savePath);
    } else {

      throw Exception("Download failed with status: ${response.statusCode}");
    }
  } catch (e, stacktrace) {

    isDownloading.value = false;
    EasyLoading.dismiss();
    CustomSnackBar(title: "Download Failed", msg: "Error: $e", isSuccess: false).showSnackBar();
  }
}


Future<Directory?> getDownloadDirectory() async {
  if (Platform.isAndroid) {
    final downloadsPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD);
    final customFolderPath = '$downloadsPath/Admission Group';
    final customFolder = Directory(customFolderPath);

    if (!await customFolder.exists()) {
      await customFolder.create(recursive: true);
    }

    return customFolder;
  } else if (Platform.isIOS) {
    return await getApplicationDocumentsDirectory();
  }
  return null;
}

*/



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/local_services.dart';



var isDownloading = false.obs;
var downloadProgress = 0.0.obs;

/// Request necessary permissions
Future<bool> requestPermissions() async {
  if (Platform.isAndroid) {
    // Android 11+ MANAGE_EXTERNAL_STORAGE
    if (await Permission.manageExternalStorage.isGranted) return true;

    final result = await Permission.manageExternalStorage.request();
    return result.isGranted;
  }
  return true; // iOS: no extra permission needed
}

/// Get Downloads/Advocates Diary folder
Future<Directory> getDownloadsFolder() async {
  final downloadsDir = Directory('/storage/emulated/0/Download/Advocates Diary');
  if (!await downloadsDir.exists()) {
    await downloadsDir.create(recursive: true);
  }
  return downloadsDir;
}

/// Main download function
Future<void> downloadDocument({
  required String fileUrl,
  String? fileExtension, // optional extension
}) async {
  if (fileUrl.isEmpty) {
    Get.snackbar("Error", "File URL is empty");
    return;
  }

  final hasPermission = await requestPermissions();
  if (!hasPermission) {
    Get.snackbar("Permission Denied", "Storage permission is required");
    return;
  }

  try {
    isDownloading.value = true;
    downloadProgress.value = 0.0;
    EasyLoading.show(status: 'Downloading...');

    final downloadsDir = await getDownloadsFolder();

    // Extract file name from URL
    String fileName = fileUrl.split('/').last;

    // Check if extension exists, otherwise add default
    if (!fileName.contains('.') && fileExtension != null) {
      fileName += ".$fileExtension";
    }

    final savePath = '${downloadsDir.path}/$fileName'.replaceAll("?", "_");
    print("Saving to: $savePath");

    // Get token if you have auth
    String? token = await LocalServices.getToken(); // your LocalServices class
    final uri = Uri.parse(fileUrl);
    final response = await http.get(uri, headers: {
      if (token != null) "Authorization": "Bearer $token",
      "User-Agent": "Mozilla/5.0",
    });

    if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);

      isDownloading.value = false;
      EasyLoading.dismiss();

      // Ask user to open
      final openFile = await Get.dialog<bool>(
        AlertDialog(
          title: const Text("Download Complete"),
          content: const Text("Do you want to open the file?"),
          actions: [
            TextButton(onPressed: () => Get.back(result: false), child: const Text("No")),
            TextButton(onPressed: () => Get.back(result: true), child: const Text("Yes")),
          ],
        ),
      );

      if (openFile == true) {
        OpenFilex.open(savePath);
      }
    } else {
      throw Exception("Download failed, status: ${response.statusCode}");
    }
  } catch (e) {
    isDownloading.value = false;
    EasyLoading.dismiss();
    Get.snackbar("Download Failed", "$e");
  }
}
