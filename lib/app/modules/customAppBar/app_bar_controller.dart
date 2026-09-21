import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:share_plus/share_plus.dart';

import '../../../constraints/api_end_points.dart';
import '../../../services/local_services.dart';
import '../../../services/remote_services.dart';
import '../../routes/app_pages.dart';
import '../leadList/controllers/lead_list_controller.dart';
import '../leadList/models/user_data_with_q_form_model.dart';

class AppBarController extends GetxController {
  var isLoading = false.obs;
  var homeData = UserDataWithQFormMode().obs;

  var notificationCount=0.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    var endPoint = APIEndPoints.getHomeData;
    await RemoteServices.getRequest(endPoint: endPoint).then((value) async {
      if (value != null) {
        homeData.value = UserDataWithQFormMode.fromJson(value);
       await LocalServices.storeQForm(homeData.value.data?.qFormLink??"");
        Get.put(LeadListController());
        Get.find<LeadListController>().homeDataModel.value = homeData.value;
      }
    });
  }

  void editUserInfo() {}

  void openNotification() {
    Get.toNamed(Routes.NOTIFICATION_PAGE);
  }

  void qFormShare()async {
 await LocalServices.getQForm().then((value){
   if (value==null) {
     isLoading.value=true;
     fetchData().then((value) {
       shareLink(link: homeData.value.data?.qFormLink ?? "");
       isLoading.value=false;
     });
   } else {
     shareLink(link: value);
   }

 });



  }

  Future<void> shareLink({required String link}) async {
    final box = Get.context?.findRenderObject() as RenderBox?;
    try {
      await Share.share(
          "Please register via this link\n$link",
          subject: "Q-form link",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } on Exception catch (e) {
      print(e);
    }

  }
}
