import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/modules/contactUs/models/contact_us_model.dart';
import 'package:nwc_referral/constraints/api_end_points.dart';
import 'package:nwc_referral/services/remote_services.dart';

import '../../../../constraints/app_colors.dart';

class ContactUsController extends GetxController {

  var isLoading=false.obs;
  var contactUsModel=ContactUsModel().obs;
  @override
  void onInit() {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          //systemNavigationBarColor: AppColors.mainColorRed, // navigation bar color
          statusBarColor: AppColors.primaryColor, // status bar color
          statusBarIconBrightness: Brightness.light,   // Only honored in Android M and above
          statusBarBrightness: Brightness.light,
        ),
      );
    super.onInit();
    fetchData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  void fetchData()async{
    isLoading.value=true;
    var endPoint=APIEndPoints.getContactUsInfo;
    try {
      var response=await RemoteServices.getRequest(endPoint: endPoint);
      if(response!=null){
        contactUsModel.value=ContactUsModel.fromJson(response);
      }
    } finally {
      isLoading.value=false;
    }
  }
}
