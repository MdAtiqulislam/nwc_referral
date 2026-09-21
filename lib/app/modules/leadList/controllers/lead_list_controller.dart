
import 'package:get/get.dart';
import 'package:nwc_referral/app/utils/utils.dart';
import '../../../../constraints/api_end_points.dart';
import '../../../../services/remote_services.dart';
import '../../customAppBar/app_bar_controller.dart';
import '../models/estimated_income_model.dart';
import '../models/user_data_with_q_form_model.dart';
import '../models/lead_list_model.dart';

class LeadListController extends GetxController {
  final student = 0.obs;
  var isLoading = false.obs;
  var isLoadingLeadList = true.obs;
  var loadingMore = false.obs;

  var homeDataModel = UserDataWithQFormMode().obs;

  var leadListModel=LeadListModel().obs;
  var leads=<SingleLead>[].obs;
  var estimatedIncome=EstimatedIncomeModel().obs;

  @override
  void onInit() {
   // updateStatusBar();
    super.onInit();
  //  fetchInitData();
    getLeadListData();
  }


 /* void fetchInitData() async {
    isLoading.value=true;
    var endPoint = APIEndPoints.getHomeData;
    await RemoteServices.getRequest(endPoint: endPoint).then((value) {
      if (value != null) {
        homeDataModel.value = HomeDataModel.fromJson(value);
        isLoading.value = false;
        AppBarController appBarController = Get.put(AppBarController());
        appBarController.homeData.value = homeDataModel.value;
       // print(appBarController.homeData.value.data?.qFormLink??"No data found");
        appBarController.refresh();
      } else {
        CustomSnackBar(isSuccess: false, msg: APIEndPoints.httpErrorMSG.value)
            .showSnackBar();
        isLoading.value = false;
      }
    });
  }*/

  void getLeadListData() async {
    leads.value=[];
    isLoadingLeadList.value=true;
    var endPoint = APIEndPoints.getLeadList;
    await RemoteServices.getRequest(endPoint: endPoint).then((value) {
      if(value!=null){
        leadListModel.value=LeadListModel.fromJson(value);
        leads.value=leadListModel.value.data?.data??[];
        isLoadingLeadList.value=false;
      }else{
        isLoadingLeadList.value=false;
      }
    });
    getEstimatedIncome();
    Get.put(AppBarController());
    Get.find<AppBarController>().fetchData();
  }

  void loadMore({required String url})async{
    loadingMore.value=true;
    await RemoteServices.getRequestLoadMore(url: url).then((value){
      if(value!=null){
        leadListModel.value=LeadListModel.fromJson(value);
        leads.value+=leadListModel.value.data?.data??[];
        loadingMore.value=false;
      }else{
        loadingMore.value=false;
      }
    });
  }

  reloadData() {
    getLeadListData();
  }

  void getEstimatedIncome() async{
    var endPoint=APIEndPoints.estimatedIncome;
    await RemoteServices.getRequest(endPoint: endPoint).then((value) {
      if(value!=null){
        estimatedIncome.value=EstimatedIncomeModel.fromJson(value);
      }
    });
  }
}
