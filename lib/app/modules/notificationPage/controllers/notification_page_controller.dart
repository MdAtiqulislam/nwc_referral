import 'package:get/get.dart';

import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../customAppBar/app_bar_controller.dart';
import '../models/notification_list_model.dart';


class NotificationPageController extends GetxController {
  var notificationListModel = NotificationListModel().obs;
  var notifications=<SingleNotificationModel>[].obs;
  var isLoading = false.obs;
  var loadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }


  @override
  void onClose() {}

  void fetchData() async {
    isLoading.value = true;
    notifications.value=[];
    var endPoint = APIEndPoints.getNotification;
    await RemoteServices.getRequest(endPoint: endPoint).then((value) {
      if (value != null) {
        notificationListModel.value = NotificationListModel.fromJson(value);
        notifications.value=notificationListModel.value.data?.data??[];
        isLoading.value = false;
      } else {
        CustomSnackBar(msg: APIEndPoints.httpErrorMSG.value, isSuccess: false)
            .showSnackBar();
        isLoading.value = false;
      }
    });
  }

  void changeNotificationReadStatus({required int id}) async {
    var endPoint = APIEndPoints.changeNotificationReadStatus;
    var parameters = {"id": id.toString()};

    await RemoteServices.getRequest(endPoint: endPoint, parameters: parameters)
        .then((value) {
          if(value!=null){
            fetchData();
            Get.put(AppBarController());
            Get.find<AppBarController>().fetchData();
          }
    });
  }

  void deleteNotification({required int id}) async{
    isLoading.value=true;
    var endPoint = APIEndPoints.removeNotification;
    var parameters = {"id": id.toString()};
    await RemoteServices.getRequest(endPoint: endPoint, parameters: parameters)
        .then((value) {
      if(value!=null){
        fetchData();
        Get.put(AppBarController());
        Get.find<AppBarController>().fetchData();
        isLoading.value=false;
      }
      else{
        isLoading.value=false;
      }
    });
  }

  void loadMore({required url})async {
    loadingMore.value=true;
    await RemoteServices.getRequestLoadMore(url: url).then((value) {

      if(value!=null){
        notificationListModel.value=NotificationListModel.fromJson(value);
        notifications.value+=notificationListModel.value.data?.data??[];
        loadingMore.value=false;
      }else{
        loadingMore.value=false;
      }
    });
  }
}
