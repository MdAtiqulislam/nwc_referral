import 'package:get/get.dart';
import 'package:nwc_referral/app/data/user_data_model.dart';
import 'package:nwc_referral/app/modules/homePage/models/home_page_data_model.dart';
import 'package:nwc_referral/app/utils/utils.dart';
import 'package:nwc_referral/constraints/api_end_points.dart';
import 'package:nwc_referral/services/local_services.dart';
import 'package:nwc_referral/services/remote_services.dart';

import '../../leadList/models/estimated_income_model.dart';

class HomePageController extends GetxController {

  var isLoading=false.obs;
  var userData=UserDataModel().obs;
  var homeData=HomePageModel().obs;
  var estimatedIncome=EstimatedIncomeModel().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    updateStatusBar();
    getUserData();
    await getHomeData().then((value) async {
      await getEstimatedIncome();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getUserData()async {
    userData.value=await LocalServices.getUser()??UserDataModel();
  }

  Future<void> getHomeData()async {
    isLoading.value=true;
    var endPoint=APIEndPoints.getHomeData2;
    try {
      var response=await RemoteServices.getRequest(endPoint: endPoint);
      if(response!=null){
        homeData.value=HomePageModel.fromJson(response);
        await LocalServices.storeQForm(homeData.value.data?.qFormLink??"");
      }
    } finally {
      isLoading.value=false;
    }
  }

  Future<void> getEstimatedIncome() async{
    isLoading.value=true;
    var endPoint=APIEndPoints.estimatedIncome;
    await RemoteServices.getRequest(endPoint: endPoint).then((value) {
      try {
        if(value!=null){
          estimatedIncome.value=EstimatedIncomeModel.fromJson(value);
        }
      } finally {
        isLoading.value=false;
      }
    });
  }
}
