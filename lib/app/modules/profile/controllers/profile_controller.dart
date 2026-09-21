import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nwc_referral/app/data/user_data_model.dart';
import 'package:nwc_referral/app/utils/utils.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/header_text.dart';
import '../../../../services/local_services.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../registration/models/country_list_model.dart';
import '../../registration/models/office_list_model.dart';

class ProfileController extends GetxController {


  var userData=UserDataModel().obs;
  var isLoading = false.obs;
  var disableOffice=true.obs;

  //office dropdown
  final officeList = <SingleOffice>[].obs;
  final countryList = <SingleCountry>[].obs;
  final selectedOffice = SingleOffice().obs;
  final selectedCountry = SingleCountry().obs;


  @override
  void onInit() {
    updateStatusBar();
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
  Future<void> getUserData() async {
    await LocalServices.getUser().then((value) {
      if (value != null) {
        userData.value = value;
      }
    });
  }

  Future<void> getCountryList() async {
    await RemoteServices.getCountryList().then((value) {
      if (value != null) {
        countryList.value = value;
        selectedCountry.value=userData.value.country!=null?countryList[countryList.indexWhere((element) => element.id==userData.value.country)]:countryList[0];
      }
    });
  }

  Future<void> getOfficeData() async {
    officeList.value = [];
    var parameters={
      "company_id":"2188"
    };
    await RemoteServices.getRequest(endPoint: APIEndPoints.officeList,parameters: parameters)
        .then((value) {
      var officeListModel = OfficeListModel();
      if (value != null) {
        officeListModel = OfficeListModel.fromJson(value);
        officeList.value = officeListModel.data ?? [];
        try{
          selectedOffice.value=userData.value.officeId!=null?officeList[officeList.indexWhere((element) => element.id==userData.value.officeId)]:officeList[0];
        }catch(e){
          selectedOffice.value=SingleOffice();
          disableOffice.value=false;
        }
         }
      isLoading.value = false;
    });
  }

  void fetchData() async {
    isLoading.value=true;
    disableOffice.value=true;
    await getUserData().then((value) async {
      await getCountryList().then((value) async {
        await getOfficeData().then((value) {
          isLoading.value=false;
        });
      });
    });
  }

  void logOut() {
    showDialog(
        context: Get.context!,
        builder: (buildContext) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,//AppDimensions.horizontalPadding,
                vertical: 24.h,//AppDimensions.verticalPadding
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r)
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(AppImagePath.warningIcon),
                    SizedBox(height: 16.h//AppDimensions.widgetPaddingVer,
                    ),
                    //  const CustomCircleAvatar(width: 50, height: 50, image: AppImagePath.warningIcon),
                    const HeaderText(text: "Are you sure you want to log out?"),
                    SizedBox(height: 32.h//AppDimensions.sectionPaddingVer,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(text: "Cancel", onTap: (){
                          Get.back();
                        },bgColor: AppColors.primaryColor,),
                        SizedBox(width: 16.w//AppDimensions.widgetPaddingHor,
                        ),
                        AppButton(text: "Confirm", onTap: (){
                          Get.offAllNamed(Routes.LOGIN);
                          LocalServices.deleteData();
                        },),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
