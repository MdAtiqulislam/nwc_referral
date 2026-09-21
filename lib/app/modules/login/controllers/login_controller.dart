/*

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/utils/extensions.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../data/user_data_model.dart';
import '../../../routes/app_pages.dart';
import '../../otpPage/controllers/otp_page_controller.dart';
import '../models/login_model.dart';


class LoginController extends GetxController {
  final showPassword = false.obs;
  final isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final loginModel = LoginModel().obs;



  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void onClose() {}

  void login() async {
    isLoading.value = true;
    var body = {
      "email": emailController.text,
      "password": passwordController.text
    };
    try {
      RemoteServices.postRequest(endPoint: APIEndPoints.login, body: body)
          .then((value) async {
        if (value != null) {
          loginModel.value = LoginModel.fromJson(value);
          if((loginModel.value.data?.companyId??0)==2188){
            await LocalServices.storeToken(loginModel.value.apiToken ?? "");
            await LocalServices
                .storeUser(loginModel.value.data ?? UserDataModel());
            if(await (loginModel.value.data??UserDataModel()).userStatus()){
              Get.offAllNamed(Routes.HOME_PAGE);
            }else{
              Get.offAllNamed(Routes.PENDING_PAGE);
            }
          }else{
            CustomSnackBar(
              isSuccess: false,
              msg: "Invalid email or password. Please check your credentials and try again."
            ).showSnackBar();
          }
        } else {
          CustomSnackBar(
                  msg: APIEndPoints.httpErrorMSG.value,
                  isSuccess: false,
                  duration: 3)
              .showSnackBar();
        }
      });
    } finally {
      isLoading.value=false;
    }
  }

  void getOTPForResetPassword() async {
    isLoading.value=true;
    var endPoint = APIEndPoints.getOTP;
    var body = {
      "email": emailController.text,
      "source":"reset_password",
      "office_id":"0"
    };

    await RemoteServices.postRequest(endPoint: endPoint, body: body)
        .then((value) {
          if(value!=null){
            Get.back();
            var otpController=Get.put(OtpPageController());
            otpController.isResetPassword.value=true;
            otpController.email.value=emailController.text;
            isLoading.value=false;
            Get.toNamed(Routes.OTP_PAGE);
          }else{
            CustomSnackBar(
              isSuccess: false,
              msg: APIEndPoints.httpErrorMSG.value
            ).showSnackBar();
            isLoading.value=false;
          }

    });
  }
}
*/

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/utils/extensions.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../data/user_data_model.dart';
import '../../../routes/app_pages.dart';
import '../../otpPage/controllers/otp_page_controller.dart';
import '../models/login_model.dart';

class LoginController extends GetxController {
  final showPassword = false.obs;
  final isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final loginModel = LoginModel().obs;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      CustomSnackBar(
        isSuccess: false,
        msg: "Email and password are required.",
      ).showSnackBar();
      return;
    }

    isLoading.value = true;
    var body = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim()
    };

    try {
      var value = await RemoteServices.postRequest(
        endPoint: APIEndPoints.login,
        body: body,
      );

      if (value != null) {
        loginModel.value = LoginModel.fromJson(value);

        if ((loginModel.value.data?.companyId ?? 0) == 2188) {
          await LocalServices.storeToken(loginModel.value.apiToken ?? "");
          await LocalServices.storeUser(loginModel.value.data ?? UserDataModel());

          if (await (loginModel.value.data ?? UserDataModel()).userStatus()) {
            Get.offAllNamed(Routes.HOME_PAGE);
          } else {
            Get.offAllNamed(Routes.PENDING_PAGE);
          }
        } else {
          CustomSnackBar(
            isSuccess: false,
            msg: "Invalid email or password. Please check your credentials.",
          ).showSnackBar();
        }
      } else {
        CustomSnackBar(
          msg: APIEndPoints.httpErrorMSG.value,
          isSuccess: false,
        ).showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void getOTPForResetPassword() async {
    if (emailController.text.isEmpty) {
      CustomSnackBar(
        isSuccess: false,
        msg: "Please enter your email to reset your password.",
      ).showSnackBar();
      return;
    }

    isLoading.value = true;
    var endPoint = APIEndPoints.getOTP;
    var body = {
      "email": emailController.text.trim(),
      "source": "reset_password",
      "office_id": "0"
    };

    try {
      var value = await RemoteServices.postRequest(
        endPoint: endPoint,
        body: body,
      );

      if (value != null) {
        Get.back();
        var otpController = Get.put(OtpPageController());
        otpController.isResetPassword.value = true;
        otpController.email.value = emailController.text.trim();
        Get.toNamed(Routes.OTP_PAGE);
      } else {
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value,
        ).showSnackBar();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
