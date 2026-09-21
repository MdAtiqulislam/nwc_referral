import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../otpPage/controllers/otp_page_controller.dart';
import '../models/country_list_model.dart';
import '../models/office_list_model.dart';

class RegistrationController extends GetxController {
  final isLoading = true.obs;
  final isEmailExist = false.obs;

  //office dropdown
  final officeList = <SingleOffice>[].obs;
  final selectedOffice = SingleOffice().obs;

  //country dropdown
  final countryList = <SingleCountry>[].obs;
  final selectedCountry = SingleCountry().obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final occupationController=TextEditingController();
  final officeController=TextEditingController();

  final selectedPhoneCountry=SingleCountry().obs;

  var phoneCountryController=TextEditingController();


  @override
  void onInit() {
    super.onInit();
   // fetchData();
  }



  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    cityController.dispose();
    occupationController.dispose();
  }

  @override
  void onClose() {}

  Future<void> getOfficeData() async {
    try {
      isLoading.value = true;
      officeList.clear();

      var parameters = {"company_id": "2188"};
      var response = await RemoteServices.getRequest(
          endPoint: APIEndPoints.officeList, parameters: parameters);

      if (response != null) {
        var officeListModel = OfficeListModel.fromJson(response);
        officeList.value = officeListModel.data ?? [];
      }
    } catch (e) {
      CustomSnackBar(
        msg: "Failed to fetch office data. Please try again.",
        isSuccess: false,
      ).showSnackBar();
    }
  }

  Future<void> getCountryList() async {
    try {
      countryList.clear();
      var response = await RemoteServices.getCountryList();
      if (response != null) {
        countryList.value = response;
      }
    } catch (e) {
      CustomSnackBar(
        msg: "Failed to fetch country list. Please check your internet connection.",
        isSuccess: false,
      ).showSnackBar();
    }
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    await Future.wait([
      getOfficeData(),
      getCountryList(),
    ]);
    isLoading.value = false;
  }


  void getOTP() async {
    isLoading.value = true;
    isEmailExist.value = false;

    var endPoint = APIEndPoints.getOTP;
    var body = {
      "email": emailController.text,
      "source": "sign_up",
      "office_id": selectedOffice.value.id.toString(),
    };

    try {
      var response = await RemoteServices.postRequest(endPoint: endPoint, body: body);

      if (response != null) {
        _setupOtpController();
        Get.toNamed(Routes.OTP_PAGE);
      } else {
        CustomSnackBar(
          msg: "It looks like you already have an account. Please contact your nearest office.",
          isSuccess: false,
        ).showSnackBar();
        isEmailExist.value = true;
      }
    } catch (e) {
      CustomSnackBar(
        msg: "An error occurred while processing your request. Please try again.",
        isSuccess: false,
      ).showSnackBar();
    } finally {
      isLoading.value = false;
    }
  }

  void _setupOtpController() {
    var otpController = Get.put(OtpPageController());
    otpController.resetFields();
    otpController.name.value = nameController.text;
    otpController.phone.value = "+${selectedCountry.value.callingCode}${phoneController.text}";
    otpController.email.value = emailController.text;
    otpController.country.value = selectedCountry.value;
    otpController.occupation.value = occupationController.text;
    otpController.city.value = cityController.text;
    otpController.office.value = selectedOffice.value;
    otpController.phoneCountry.value = selectedPhoneCountry.value;
  }


}
