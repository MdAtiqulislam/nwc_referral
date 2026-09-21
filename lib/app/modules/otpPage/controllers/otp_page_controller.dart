/*
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/utils/extensions.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../data/user_data_model.dart';
import '../../../routes/app_pages.dart';
import '../../registration/models/country_list_model.dart';
import '../../registration/models/office_list_model.dart';
import '../models/sign_up_model.dart';


class OtpPageController extends GetxController {

  var isLoading = false.obs;
  var isValidate = false.obs;
  var showPassword = false.obs;
  var isResetPassword = false.obs;
  var resendOtpTime = 60.obs;

  var name = "".obs;
  var email = "".obs;
  var phone = "".obs;
  var country = SingleCountry().obs;
  var phoneCountry = SingleCountry().obs;
  var city = "".obs;
  var occupation = "".obs;
  var office = SingleOffice().obs;

  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  final c4 = TextEditingController();
  final c5 = TextEditingController();
  final c6 = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var signUpModel = SignUpModel().obs;

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }


  @override
  void onClose() {
    resetFields();
  }

  void checkOtpLength(String? value) {
    if ((value ?? "").length >= 6) {
      c1.text = value![0];
      c2.text = value[1];
      c3.text = value[2];
      c4.text = value[3];
      c5.text = value[4];
      c6.text = value[5];
      verifyOTP();
    }
  }

  void verifyOTP() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.verifyOTP;
    String otp=c1.text + c2.text + c3.text + c4.text + c5.text + c6.text;
    var body = {
      "otp": otp,
      "email": email.value,
    };

    await RemoteServices.postRequest(endPoint: endPoint, body: body)
        .then((value) {
      if (value != null) {
        isValidate.value = true;
        isLoading.value = false;
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value)
            .showSnackBar();
        isLoading.value = false;
      }
    });
  }

  void completeRegistration() async {
    isLoading.value=true;
    if (passwordController.text == confirmPasswordController.text) {
      var endPoint = APIEndPoints.signUp;
      var body = {
        "name": name.value,
        "office_id": office.value.id.toString(),
        "email": email.value,
        "phone": phone.value,
        "country": country.value.id.toString(),
        "phone_country_id": phoneCountry.value.id.toString(),
        "city": city.value,
        "source_occupation": occupation.value,
        "password": passwordController.text,
      };


      await RemoteServices.postRequest(endPoint: endPoint, body: body)
          .then((value) async {
        if (value != null) {
          signUpModel.value = SignUpModel.fromJson(value);
          LocalServices.storeToken(signUpModel.value.apiToken ?? "");
          LocalServices.storeUser(signUpModel.value.data ?? UserDataModel());
          isLoading.value = false;
          CustomSnackBar(msg: signUpModel.value.msg ?? "", isSuccess: true)
              .showSnackBar();
          if (await (signUpModel.value.data ?? UserDataModel()).userStatus()) {
            Get.offAllNamed(Routes.HOME_PAGE);
          } else {
            Get.offAllNamed(Routes.PENDING_PAGE);
          }
        } else {
          CustomSnackBar(
            msg: APIEndPoints.httpErrorMSG.value,
            isSuccess: false,
          ).showSnackBar();

          isLoading.value = false;
        }
      });
    } else {
      CustomSnackBar(
              isSuccess: false, msg: "Password did not match.", duration: 3)
          .showSnackBar();
    }
  }

  void resetFields() {
    isLoading.value = false;
    isValidate.value = false;
    showPassword.value = false;
    isResetPassword.value = false;
    name.value = "";
    email.value = "";
    phone.value = "";
    country.value = SingleCountry();
    city.value = "";
    occupation.value = "";
    office.value = SingleOffice();
    c1.text = "";
    c2.text = "";
    c3.text = "";
    c4.text = "";
    c5.text = "";
    c6.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
  }

 void resetPassword() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.resetPassword;
    var body = {
      "email": email.value,
      "password": passwordController.text,
    };

    await RemoteServices.postRequest(endPoint: endPoint, body: body)
        .then((value) {
      if (value != null) {
        Get.offAllNamed(Routes.LOGIN);
        CustomSnackBar(isSuccess: true, msg: value["msg"]).showSnackBar();
        isLoading.value = false;
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value)
            .showSnackBar();
        isLoading.value = false;
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOtpTime.value > 0) {
        resendOtpTime.value--;
      }
      if (resendOtpTime.value <= 0) {
        resendOtpTime.value = 0;
        timer.cancel();
      }
      if(isValidate.value){
        timer.cancel();
      }
    });
  }

  void resendOTP() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.getOTP;
    var body = {
      "email": email.value,
      "source": isResetPassword.value ? "reset_password" : "sign_up",
      "office_id":(office.value.id==null?"0":office.value.id.toString())
    };

    await RemoteServices.postRequest(endPoint: endPoint, body: body)
        .then((value) {
      if (value != null) {
        CustomSnackBar(isSuccess: true, msg: value["msg"]).showSnackBar();
        isLoading.value = false;
        resendOtpTime.value = 180;
        startTimer();
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value)
            .showSnackBar();
        isLoading.value = false;
      }
    });
  }
}
*/

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/utils/extensions.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../data/user_data_model.dart';
import '../../../routes/app_pages.dart';
import '../../registration/models/country_list_model.dart';
import '../../registration/models/office_list_model.dart';
import '../models/sign_up_model.dart';

class OtpPageController extends GetxController {
  var isLoading = false.obs;
  var isValidate = false.obs;
  var showPassword = false.obs;
  var isResetPassword = false.obs;
  var resendOtpTime = 60.obs;

  var name = "".obs;
  var email = "".obs;
  var phone = "".obs;
  var country = SingleCountry().obs;
  var phoneCountry = SingleCountry().obs;
  var city = "".obs;
  var occupation = "".obs;
  var office = SingleOffice().obs;

  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  final c4 = TextEditingController();
  final c5 = TextEditingController();
  final c6 = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var signUpModel = SignUpModel().obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    resetFields();
    timer?.cancel();
  }

  void checkOtpLength(String? value) {
    if ((value ?? "").length >= 6) {
      for (int i = 0; i < 6; i++) {
        [c1, c2, c3, c4, c5, c6][i].text = value![i];
      }
      verifyOTP();
    }
  }

  Future<void> verifyOTP() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.verifyOTP;
    String otp = "${c1.text}${c2.text}${c3.text}${c4.text}${c5.text}${c6.text}";

    var body = {"otp": otp, "email": email.value};

    try {
      var response = await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response != null) {
        isValidate.value = true;
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } catch (e) {
      CustomSnackBar(isSuccess: false, msg: "OTP verification failed. Please try again.").showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeRegistration() async {
    if (passwordController.text != confirmPasswordController.text) {
      CustomSnackBar(isSuccess: false, msg: "Passwords do not match.").showSnackBar();
      return;
    }

    isLoading.value = true;
    var endPoint = APIEndPoints.signUp;
    var body = {
      "name": name.value,
      "office_id": office.value.id?.toString() ?? "0",
      "email": email.value,
      "phone": phone.value,
      "country": country.value.id?.toString() ?? "0",
      "phone_country_id": phoneCountry.value.id?.toString() ?? "0",
      "city": city.value,
      "source_occupation": occupation.value,
      "password": passwordController.text,
    };

    try {
      var response = await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response != null) {
        signUpModel.value = SignUpModel.fromJson(response);
        await LocalServices.storeToken(signUpModel.value.apiToken ?? "");
        await LocalServices.storeUser(signUpModel.value.data ?? UserDataModel());

        CustomSnackBar(msg: signUpModel.value.msg ?? "", isSuccess: true).showSnackBar();

        if (await (signUpModel.value.data ?? UserDataModel()).userStatus()) {
          Get.offAllNamed(Routes.HOME_PAGE);
        } else {
          Get.offAllNamed(Routes.PENDING_PAGE);
        }
      } else {
        CustomSnackBar(msg: APIEndPoints.httpErrorMSG.value, isSuccess: false).showSnackBar();
      }
    } catch (e) {
      CustomSnackBar(msg: "Registration failed. Please try again.", isSuccess: false).showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.resetPassword;
    var body = {"email": email.value, "password": passwordController.text};

    try {
      var response = await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response != null) {
        Get.offAllNamed(Routes.LOGIN);
        CustomSnackBar(isSuccess: true, msg: response["msg"]).showSnackBar();
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } catch (e) {
      CustomSnackBar(isSuccess: false, msg: "Password reset failed. Please try again.").showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }

  void resetFields() {
    isLoading.value = false;
    isValidate.value = false;
    showPassword.value = false;
    isResetPassword.value = false;
    name.value = "";
    email.value = "";
    phone.value = "";
    country.value = SingleCountry();
    city.value = "";
    occupation.value = "";
    office.value = SingleOffice();
    for (var controller in [c1, c2, c3, c4, c5, c6]) {
      controller.text = "";
    }
    passwordController.text = "";
    confirmPasswordController.text = "";
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendOtpTime.value > 0) {
        resendOtpTime.value--;
      } else {
        resendOtpTime.value = 0;
        timer.cancel();
      }
      if (isValidate.value) {
        timer.cancel();
      }
    });
  }

  Future<void> resendOTP() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.getOTP;
    var body = {
      "email": email.value,
      "source": isResetPassword.value ? "reset_password" : "sign_up",
      "office_id": office.value.id?.toString() ?? "0"
    };

    try {
      var response = await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response != null) {
        CustomSnackBar(isSuccess: true, msg: response["msg"]).showSnackBar();
        resendOtpTime.value = 180;
        startTimer();
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value).showSnackBar();
      }
    } catch (e) {
      CustomSnackBar(isSuccess: false, msg: "Failed to resend OTP. Please try again.").showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }
}
