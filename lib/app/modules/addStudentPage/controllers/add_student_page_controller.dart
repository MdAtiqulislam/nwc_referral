import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nwc_referral/app/other_models/additional_files_model.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/utils.dart';
import '../../leadList/controllers/lead_list_controller.dart';
import '../../leadList/models/lead_list_model.dart';
import '../../registration/models/country_list_model.dart';
import 'package:path/path.dart' as path;

class AddStudentPageController extends GetxController {
  final isLoading = false.obs;
  final isAccepted = false.obs;
  final isEmailExist = true.obs;
  final isUpdateForm = false.obs;
  final isUpdating = false.obs;

  final genderList = ["Male", "Female"];
  final selectedGender = "".obs;
  final selectedCountry = SingleCountry().obs;
  final selectedPhoneCountry = SingleCountry().obs;
  final countryList = <SingleCountry>[].obs;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final notesController = TextEditingController();
  var lead = SingleLead().obs;
  final countryNameController = TextEditingController();
  final countryCodeController = TextEditingController();

  var selectedDocuments = <Map<String, dynamic>>[].obs;
  var uploadedDocuments = AdditionalFileListModel().obs;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    getCountryList();
    super.onInit();
  }

  @override
  void onClose() {}

  Future<void> getCountryList() async {
    isLoading.value = true;
    countryList.value = [];
    await RemoteServices.getCountryList().then((value) {
      if (value != null) {
        countryList.value = value;
        isLoading.value = false;
        //selectedCountry.value = countryList[0];
        //selectedPhoneCountry.value = countryList[0];
        //countryCodeController.text=selectedPhoneCountry.value.iso31662??"";
        // countryNameController.text=selectedCountry.value.name??"";
        // coun.text=selectedPhoneCountry.value.name??"";
      } else {
        isLoading.value = false;
      }
    });
  }

  void addStudent() async {
    if (isAccepted.value) {
      isUpdating.value = true;
      await checkEmail().then((value) async {
        if (value) {
          submitStudentForm();
        } else {
          isUpdating.value = false;
        }
      });
    } else {
      CustomSnackBar(
              msg:
                  "You have to agree with Admission Group terms and condition first.",
              isSuccess: false)
          .showSnackBar();
    }
  }

  Future<bool> checkEmail() async {
    isEmailExist.value = true;
    var endPoint = APIEndPoints.checkEmail;
    var body = {"email": emailController.text};
    await RemoteServices.postRequest(endPoint: endPoint, body: body)
        .then((value) {
      value == null
          ? isEmailExist.value = false
          : value["msg"] == "Email not exist."
              ? isEmailExist.value = true
              : isEmailExist.value = false;
    });
    return isEmailExist.value;
  }

  void submitStudentForm() async {
    var endPoint = APIEndPoints.addNewStudent;
    var body = {
      "mobile":
          "+${selectedPhoneCountry.value.callingCode}${phoneController.text}",
      "given_name": firstNameController.text,
      "family_name": lastNameController.text,
      "email": emailController.text,
      "gender": selectedGender.value.isEmpty ? "" : selectedGender.value,
      "nationalities_id": selectedCountry.value.id.toString(),
      "mobile_country_id": selectedPhoneCountry.value.id.toString(),
      "notes": notesController.text
    };
    await RemoteServices.postRequest(endPoint: endPoint, body: body)
        .then((value) async {
      if (value != null) {
        await uploadLeadAdditionalFile(leadId: value["data"]["id"].toString())
            .then((value_uploaded) {
          Get.offAllNamed(Routes.HOME_PAGE);
          CustomSnackBar(msg: value["msg"], isSuccess: true).showSnackBar();
          isUpdating.value = false;
        });
      } else {
        CustomSnackBar(msg: APIEndPoints.httpErrorMSG.value, isSuccess: false)
            .showSnackBar();
        isUpdating.value = false;
      }
    });
  }

  void preLoadData() async {
    await getCountryList().then((value) async {
      firstNameController.text = lead.value.givenName ?? "";
      lastNameController.text = lead.value.familyName ?? "";
      emailController.text = lead.value.email ?? "";
      selectedGender.value =
          (lead.value.gender ?? "") == "NULL" ? "" : lead.value.gender ?? "";
      notesController.text = lead.value.notes ?? "";
      /*if (lead.value.nationalitiesId != null) {
        selectedCountry.value = countryList[countryList
            .indexWhere((element) => element.id == lead.value.nationalitiesId)];
        countryNameController.text = selectedCountry.value.name ?? "";
      } else {*/
      selectedCountry.value = countryList[0];
      countryNameController.text = "";
      //}

      if (lead.value.mobileCountryId != null) {
        selectedPhoneCountry.value = countryList[countryList
            .indexWhere((element) => element.id == lead.value.mobileCountryId)];
        phoneController.text = (lead.value.mobile ?? "")
            .replaceAll("+${selectedPhoneCountry.value.callingCode}", "");
      } else {
        selectedPhoneCountry.value = countryList[0];
        phoneController.text = (lead.value.mobile ?? "")
            .replaceAll("+${selectedPhoneCountry.value.callingCode}", "");
      }
      countryCodeController.text = selectedPhoneCountry.value.iso31662 ?? "";
      await getAdditionalFiles(leadId: lead.value.id.toString());
    });
  }

  void updateUserInfo() async {
    if (isAccepted.value) {
      isUpdating.value = true;
      var endPoint = APIEndPoints.updateLead;
      var body = {
        "lead_id": lead.value.id.toString(),
        "given_name": firstNameController.text,
        "family_name": lastNameController.text,
        "gender": selectedGender.value.isEmpty ? "" : selectedGender.value,
        "nationalities_id": selectedCountry.value.id.toString(),
        "mobile_country_id": selectedPhoneCountry.value.id.toString(),
        "notes": notesController.text,
        "email": emailController.text == lead.value.email
            ? ""
            : emailController.text,
        "mobile":
            "+${selectedPhoneCountry.value.callingCode}${phoneController.text}",
      };

      if (emailController.text != lead.value.email) {
        await checkEmail().then((value) async {
          if (value) {
            completeUpdate(endPoint: endPoint, body: body);
          } else {
            isUpdating.value = false;
          }
        });
      } else {
        completeUpdate(endPoint: endPoint, body: body);
      }
    } else {
      CustomSnackBar(
              msg:
                  "You have to agree with Admission Group terms and condition first.",
              isSuccess: false)
          .showSnackBar();
    }
  }

  Future<void> completeUpdate(
      {required String endPoint, required Map<String, dynamic> body}) async
  {
    await RemoteServices.postRequest(endPoint: endPoint, body: body)
        .then((value) async {
      if (value != null) {
        if (selectedDocuments.isNotEmpty) {
          await uploadLeadAdditionalFile(leadId: lead.value.id.toString());
        } else {
          CustomSnackBar(msg: value["msg"], isSuccess: true).showSnackBar();
          isUpdating.value = false;
        }

        // resetFields();
        Get.put(LeadListController());
        Get.find<LeadListController>().getLeadListData();
      } else {
        CustomSnackBar(msg: APIEndPoints.httpErrorMSG.value, isSuccess: false)
            .showSnackBar();
        isUpdating.value = false;
      }
    });
  }

  void resetFields() {
    isUpdateForm.value = false;
    isLoading.value = false;
    isEmailExist.value = true;
    lead.value = SingleLead();
    firstNameController.text = "";
    lastNameController.text = "";
    phoneController.text = "";
    emailController.text = "";
    countryNameController.text = "";
    countryCodeController.text = "";
    selectedGender.value = "";
    selectedCountry.value = SingleCountry();
    selectedPhoneCountry.value = SingleCountry();
    notesController.text = "";
    selectedDocuments.value = [];
    uploadedDocuments.value=AdditionalFileListModel();
  }

  Future<void> handleDocumentSelection() async {
    List<Map<String, dynamic>> documents = await selectDocuments();
    if (documents.isNotEmpty) {
      selectedDocuments.value.addAll(documents);
      selectedDocuments.refresh();
      Get.back();
      for (var doc in selectedDocuments) {
        print(
            "Selected document: ${doc['name']} at ${doc['path']} extension ${doc['extension']}");
      }
    } else {
      print("No selectedDocuments selected.");
    }
  }

  // Rename a document by index
  void renameDocument(int index, String newName) {
    if (index >= 0 && index < selectedDocuments.length) {
      selectedDocuments[index]['name'] = newName;
      selectedDocuments.refresh(); // Trigger reactive update
    }
  }

  // Remove a document by index
  void removeSelectedDocument(int index) {
    selectedDocuments.removeAt(index);
  }

  Future<void> uploadLeadAdditionalFile({required String leadId}) async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.uploadLeadAdditionalFile;

    try {
      var response = await RemoteServices.uploadMultipleFiles(
        selectedDocument: selectedDocuments.value,
        endPoint: endPoint,
        requestType: 'POST',
        leadId: leadId,
      );

      if (response != null) {
        selectedDocuments.value = [];
        getAdditionalFiles(leadId: leadId);
      }
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> getAdditionalFiles({required String leadId}) async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.getLeadAdditionalFile;
    var parameters = {
      "lead_id": leadId,
    };
    try {
      var response = await RemoteServices.getRequest(
          endPoint: endPoint, parameters: parameters);
      if (response != null) {
        uploadedDocuments.value = AdditionalFileListModel.fromJson(response);
        print(uploadedDocuments.value.data?.fileList?.data?.length);
      }
    } finally {
      isUpdating.value = false;
    }
  }

  void deleteDocument({int? id}) async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.deleteDocument;
    var parameters = {"id": id.toString()};

    try {
      var response = await RemoteServices.getRequest(
          endPoint: endPoint, parameters: parameters);
      if (response != null) {
        getAdditionalFiles(leadId: lead.value.id.toString());

        CustomSnackBar(msg: response["msg"], isSuccess: true).showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }
  }

  void renameUploadedDocument({int? id, required String newName}) async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.renameDocument;
    var body = {"id": id.toString(), "file_name": newName};

    try {
      var response =
          await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response != null) {
        getAdditionalFiles(leadId: lead.value.id.toString());
        CustomSnackBar(isSuccess: true, msg: response["msg"]).showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }
  }

 /* Future<void> selectImage({required ImageSource source}) async {
    try {
      // Step 1: Pick an image
      final pickedFile = await picImage(source);
      if (pickedFile != null) {
        // Close the image source selection UI
        Get.back();

        // Step 2: Crop the image
        final croppedFile = await cropImage(filePath: pickedFile.path);
        if (croppedFile != null) {
          // Step 3: Add file details to selectedDocuments
          var file = {
            'name': croppedFile.name,
            'path': croppedFile.path,
            'size': croppedFile.size, // File size in bytes
            'extension': croppedFile.extension, // File extension
          };
          selectedDocuments.value.addAll(file);

          // Optional: Handle further actions like uploading or previewing the file
          debugPrint('File selected and processed successfully: $file');
        }
      }
    } catch (e) {
      // Handle exceptions, such as errors during picking or cropping the image
      debugPrint('Error in selectImage: $e');
    }
  }

  */



  Future<void> selectImage({required ImageSource source}) async {
    try {
      // Step 1: Pick an image
      final pickedFile = await picImage(source);
      if (pickedFile != null) {
        Get.back(); // Close the image source selection UI

        // Step 2: Crop the image
        final croppedFile = await cropImage(filePath: pickedFile.path,cropStyle: CropStyle.rectangle);
        if (croppedFile != null) {
          // Step 3: Convert CroppedFile to PlatformFile
          PlatformFile? platformFile = await convertCroppedFileToPlatformFile(croppedFile);
          if (platformFile != null) {
            selectedDocuments.value.add({
              'name': platformFile.name,
              'path': platformFile.path,
              'size': platformFile.size, // File size in bytes
              'extension': platformFile.extension,});


            selectedDocuments.refresh();
          }
        }
      }
    } catch (e) {
      // Handle exceptions, such as errors during picking or cropping the image
      debugPrint('Error in selectImage: $e');
    }
  }

  Future<PlatformFile?> convertCroppedFileToPlatformFile(CroppedFile croppedFile) async {
    try {
      String fileName = path.basename(croppedFile.path);
      fileName=fileName.replaceAll("image_cropper", "image");
      File file = File(croppedFile.path);
      int fileSize = await file.length();
      Uint8List fileBytes = await file.readAsBytes();

      return PlatformFile(
        name: fileName,
        path: croppedFile.path,
        size: fileSize,
        bytes: fileBytes,
      );
    } catch (e) {
      debugPrint('Error converting CroppedFile to PlatformFile: $e');
      return null;
    }
  }

}
