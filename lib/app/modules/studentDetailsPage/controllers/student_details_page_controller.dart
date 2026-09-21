import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../../other_models/additional_files_model.dart';
import '../../../utils/utils.dart';
import '../../registration/models/country_list_model.dart';
import '../Models/lead_details_model.dart';
import 'package:path/path.dart' as path;


class StudentDetailsPageController extends GetxController {
  var isLoading = false.obs;
  var leadDetailsModel = LeadDetailsModel().obs;
  var notes="".obs;
  var isAssigned=false.obs;

  var countryList=<SingleCountry>[].obs;
  var selectedDocuments = <Map<String, dynamic>>[].obs;
  var uploadedDocuments = AdditionalFileListModel().obs;


  @override
  void onInit() {
    updateStatusBar();
    getCountry();
    super.onInit();
  }

  @override
  void onClose() {}

  void getLeadDetails({required int leadId}) async {
    isLoading.value = true;
    var endPoint = APIEndPoints.getLeadDetails;
    var parameters = {"lead_id": leadId.toString()};

    await RemoteServices.getRequest(endPoint: endPoint, parameters: parameters)
        .then((value) {

          if(value!=null){
            leadDetailsModel.value=LeadDetailsModel.fromJson(value);
            isLoading.value=false;
            getAdditionalFiles(leadId: leadDetailsModel.value.data!.id.toString());
          }else{
            CustomSnackBar(
              msg: APIEndPoints.httpErrorMSG.value,
              isSuccess: false
            ).showSnackBar();
            isLoading.value=false;
          }
    });
  }

  void getCountry()async {

    try{
      await RemoteServices.getCountryList().then((value) {
        countryList.value=value??[];
      });
    }catch(e){
      countryList.value=[];
    }
  }

 String getCountryFlag(int? country) {

    String countryFlag="";
    try{
      countryFlag=  countryList[countryList.indexWhere((element) => element.id==country)].flagUrl??"";

    }catch(e){
      countryFlag="";
    }

    print(countryFlag);
    return countryFlag;
 }


  Future<void> handleDocumentSelection() async {
    List<Map<String, dynamic>> documents = await selectDocuments();
    if (documents.isNotEmpty) {
      selectedDocuments.addAll(documents);
      selectedDocuments.refresh();
      Get.back();
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
    isLoading.value = true;
    var endPoint = APIEndPoints.uploadLeadAdditionalFile;


    try {
      var response = await RemoteServices.uploadMultipleFiles(
        selectedDocument: selectedDocuments.value,
        endPoint: endPoint,
        requestType: 'POST',
        leadId: leadId,
      );

      if(response!=null){
        selectedDocuments.value=[];
        getAdditionalFiles(leadId: leadId);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAdditionalFiles({required String leadId}) async {
    isLoading.value=true;
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
      isLoading.value=false;
    }
  }

  void deleteDocument({int? id}) async{
    isLoading.value=true;
    var endPoint=APIEndPoints.deleteDocument;
    var parameters={
      "id":id.toString()
    };

    try {
      var response=await RemoteServices.getRequest(endPoint: endPoint,parameters: parameters);
      if(response!=null){

        getAdditionalFiles(leadId: leadDetailsModel.value.data!.id.toString());

        CustomSnackBar(
            msg: response["msg"],
            isSuccess: true
        ).showSnackBar();
      }
    } finally {
      isLoading.value=false;
    }

  }

  void renameUploadedDocument({int? id,required String newName})async {
    isLoading.value=true;
    var endPoint=APIEndPoints.renameDocument;
    var body={
      "id":id.toString(),
      "file_name":newName
    };

    try {
      var response=await RemoteServices.postRequest(endPoint: endPoint,body: body);
      if(response!=null){
        getAdditionalFiles(leadId: leadDetailsModel.value.data!.id.toString());
        CustomSnackBar(
            isSuccess: true,
            msg: response["msg"]
        ).showSnackBar();
      }
    } finally {
      isLoading.value=false;
    }
  }




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
