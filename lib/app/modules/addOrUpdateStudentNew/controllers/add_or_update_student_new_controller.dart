import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nwc_referral/app/modules/addOrUpdateStudentNew/models/level_list_model.dart';
import 'package:nwc_referral/app/modules/addOrUpdateStudentNew/models/university_list_model.dart';
import 'package:nwc_referral/app/modules/leadList/controllers/lead_list_controller.dart';
import 'package:nwc_referral/app/other_models/additional_files_model.dart';
import 'package:nwc_referral/constraints/api_end_points.dart';
import '../../../../common_widgets/custom_snackbar.dart';
import '../../../../services/remote_services.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/utils.dart';
import '../../filePreview/controllers/file_preview_controller.dart';
import '../../leadList/models/lead_list_model.dart';
import '../../registration/models/country_list_model.dart';
import 'package:path/path.dart' as p;

class AddOrUpdateStudentNewController extends GetxController {
  var currentStep = 0.obs;
  final isLoading = false.obs;
  final isAccepted = false.obs;
  final isEmailExist = true.obs;
  final isUpdateForm = false.obs;
  final isUpdating = false.obs;
  final genderList = ["Male", "Female"];
  final selectedGender = "".obs;
  final selectedCountry = SingleCountry().obs;
  final destinationCountry = SingleCountry().obs;
  final selectedPhoneCountry = SingleCountry().obs;
  final countryList = <SingleCountry>[].obs;
  final destinationCountryList = <SingleCountry>[].obs;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final notesController = TextEditingController();

  var lead = SingleLead().obs;
  final countryNameController = TextEditingController();
  final countryCodeController = TextEditingController();

  var universityList = UniversityListModel().obs;
  var selectedUniversity = SingleUniversity().obs;

  var courseList = LevelListModel().obs;
  var selectedLevel = SingleCourse().obs;

  final months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  var selectedMonth = "".obs;
  var selectedYear = "".obs;

  final tuitionFeeRanges = ["Up to £12,000", "Up to £14,000", "Above £15,000"];
  final selectedRange = "".obs;

  var isSelfReferring = true.obs;
  var hasVisaRefusal = false.obs;

  var leadId = "".obs;
  var yearsList = <String>[].obs;

  RxList<File> academicFile = <File>[].obs;
  RxList<File> cvFile = <File>[].obs;
  RxList<File> passportFile = <File>[].obs;
  RxList<File> additionalFiles = <File>[].obs;

  var uploadedCVFile = <SingleFile>[].obs;

  var uploadedAcademicFile = <SingleFile>[].obs;
  var uploadedPassportFile = <SingleFile>[].obs;
  RxList<SingleFile> uploadedAdditionalFiles = <SingleFile>[].obs;

  // Map to track progress of each file
  RxMap<String, double> uploadProgress = <String, double>{}.obs;

  var uploadedDocuments = AdditionalFileListModel().obs;

  @override
  Future<void> onInit() async {
    updateStatusBar();
    yearsList.value = getUpcomingYears(count: 5);
    print("yearsList:$yearsList");
    super.onInit();
  }

  Future<void> getCountryList() async {
    isLoading.value = true;
    countryList.value = [];
    await RemoteServices.getCountryList().then((value) {
      countryList.value = value;
      isLoading.value = false;
    });
  }

  void nextStep() {
    if (currentStep < 2) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep.value--;
    }
  }

  Future<void> getUniversityList() async {
    isLoading.value = true;
    var endPoint = APIEndPoints.getUniversityList;
    try {
      var response = await RemoteServices.getRequest(endPoint: endPoint);
      if (response != null) {
        universityList.value = UniversityListModel.fromJson(response);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUniversityListByDestination(
      {required String destinationId}) async
  {
    isUpdating.value = true;
    var endPoint = APIEndPoints.universitySearch;
    var parameters = {"destination_id": destinationId};
    try {
      var response = await RemoteServices.getRequest(
          endPoint: endPoint, parameters: parameters);
      if (response != null) {
        universityList.value = UniversityListModel.fromJson(response);
      }
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> getCoursesList({required String uniID}) async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.getCoursesList;
    try {
      var response = await RemoteServices.getRequest(endPoint: endPoint);
      if (response != null) {
        courseList.value = LevelListModel.fromJson(response);
      }
    } finally {
      isUpdating.value = false;
    }
  }

  void addStudent() async {
    if (isAccepted.value) {
      isUpdating.value = true;
      await checkEmail().then((value) async {
        if (value) {
          submitStudentForm();
        } else {
          isUpdating.value = false;
        }
      });
    } else {
      CustomSnackBar(
              msg:
                  "You have to agree with Admission Group terms and condition first.",
              isSuccess: false)
          .showSnackBar();
    }
  }

  Future<bool> checkEmail() async {
    isEmailExist.value = true;
    var endPoint = APIEndPoints.checkEmail;
    var body = {"email": emailController.text};
    await RemoteServices.postRequest(endPoint: endPoint, body: body)
        .then((value) {
      value == null
          ? isEmailExist.value = false
          : value["msg"] == "Email not exist."
              ? isEmailExist.value = true
              : isEmailExist.value = false;
    });
    return isEmailExist.value;
  }

  void submitStudentForm() async {
    var endPoint = APIEndPoints.addNewStudent;
    var body = getStudentFormBody();
    try {
      await RemoteServices.postRequest(endPoint: endPoint, body: body)
          .then((value) async {
        if (value != null) {
          Get.put(LeadListController()).getLeadListData();
          Get.find<LeadListController>().getEstimatedIncome();
          leadId.value = value["data"]["id"].toString();
          nextStep();
        } else {
          CustomSnackBar(msg: APIEndPoints.httpErrorMSG.value, isSuccess: false)
              .showSnackBar();
          isUpdating.value = false;
        }
      });


    } finally {
      isUpdating.value = false;
    }
  }

/*  void preLoadData() async {
    firstNameController.text = lead.value.givenName ?? "";
    lastNameController.text = lead.value.familyName ?? "";
    emailController.text = lead.value.email ?? "";
    selectedGender.value =
        (lead.value.gender ?? "") == "NULL" ? "" : lead.value.gender ?? "";
    notesController.text = getAdditionalNotesValue(lead.value.notes ?? "");
    selectedCountry.value = countryList[0];
    countryNameController.text = "";


    if (lead.value.mobileCountryId != null) {
      int index = countryList
          .indexWhere((element) => element.id == lead.value.mobileCountryId);
      selectedPhoneCountry.value =
          (index != -1) ? countryList[index] : countryList[0];
    } else {
      selectedPhoneCountry.value = countryList[0];
    }

    phoneController.text = (lead.value.mobile ?? "")
        .replaceAll("+${selectedPhoneCountry.value.callingCode}", "");

    countryCodeController.text = selectedPhoneCountry.value.iso31662 ?? "";

    if ((lead.value.enrollments ?? []).isNotEmpty) {
      var firstEnrollment = lead.value.enrollments!.first;

      if (firstEnrollment.destinationId != null) {
        int index = countryList.indexWhere(
            (element) => element.id == firstEnrollment.destinationId);

        if (index != -1) {
          destinationCountry.value = countryList[index];
         await getUniversityListByDestination(destinationId: destinationCountry.value.id.toString()).then((value) async {
           if (firstEnrollment.levelId != null) {
             int index = (universityList.value.data?.uniData ?? []).indexWhere(
                     (element) => element.id == firstEnrollment.universityId);
             if (index != -1) {
               selectedUniversity.value =
               (universityList.value.data?.uniData ?? [])[index];
               await getCoursesList(uniID: selectedUniversity.value.id.toString()).then((value){
                 if (firstEnrollment.levelId != null) {
                   int index = (courseList.value.data?.coursesData ?? [])
                       .indexWhere((element) => element.id == firstEnrollment.levelId);

                   if (index != -1) {
                     selectedLevel.value =
                     (courseList.value.data?.coursesData ?? [])[index];
                   } else {
                     selectedLevel.value = SingleCourse(); // Assign default if not found
                   }
                 } else {
                   selectedLevel.value = SingleCourse();
                 }
               });
             } else {
               selectedUniversity.value =
                   SingleUniversity(); // Assign default if not found
             }
           } else {
             selectedUniversity.value = SingleUniversity();
           }
         });

        } else {
          destinationCountry.value =
              SingleCountry(); // Assign default if not found
        }
      } else {
        destinationCountry.value = SingleCountry();
      }
    }

    if ((lead.value.enrollments ?? []).isNotEmpty) {
      var firstEnrollment = lead.value.enrollments!.first;

      if (firstEnrollment.startDate != null) {
        selectedMonth.value =
            getFormattedMonthFromDate(firstEnrollment.startDate.toString());
      } else {
        selectedMonth.value = "";
      }

      if (firstEnrollment.startDate != null) {
        selectedYear.value =
            getYearFromDate(firstEnrollment.startDate.toString());
      } else {
        selectedYear.value = "";
      }
    }


    selectedRange.value = lead.value.tutionFeeInfoApp ?? "";
    isSelfReferring.value =
        (lead.value.referringApp ?? "").toLowerCase() == "yes";
    hasVisaRefusal.value = lead.value.hasVisaRefusal == 1;
  }*/

  void preLoadData() async {
    firstNameController.text = lead.value.givenName ?? "";
    lastNameController.text = lead.value.familyName ?? "";
    emailController.text = lead.value.email ?? "";
    selectedGender.value = (lead.value.gender?.toLowerCase() == "null") ? "" : lead.value.gender ?? "";
    notesController.text = getAdditionalNotesValue(lead.value.notes ?? "");

    selectedCountry.value = countryList[0];
    countryNameController.text = "";

    // Set Phone Country
    int phoneCountryIndex = countryList.indexWhere((e) => e.id == lead.value.mobileCountryId);
    selectedPhoneCountry.value = (phoneCountryIndex != -1) ? countryList[phoneCountryIndex] : countryList[0];

    phoneController.text = (lead.value.mobile ?? "").replaceAll("+${selectedPhoneCountry.value.callingCode}", "");
    countryCodeController.text = selectedPhoneCountry.value.iso31662 ?? "";

    // Handle Enrollment Data
    var firstEnrollment = lead.value.enrollments?.isNotEmpty == true ? lead.value.enrollments!.first : null;
    if (firstEnrollment != null) {
      // Destination Country
      int destIndex = countryList.indexWhere((e) => e.id == firstEnrollment.destinationId);
      destinationCountry.value = (destIndex != -1) ? countryList[destIndex] : SingleCountry();

      if (destinationCountry.value.id != null) {
        await getUniversityListByDestination(destinationId: destinationCountry.value.id.toString());

        // University Selection
        int uniIndex = universityList.value.data?.uniData?.indexWhere((e) => e.id == firstEnrollment.universityId) ?? -1;
        selectedUniversity.value = (uniIndex != -1) ? universityList.value.data!.uniData![uniIndex] : SingleUniversity();

        if (selectedUniversity.value.id != null) {
          await getCoursesList(uniID: selectedUniversity.value.id.toString());

          // Level Selection
          int levelIndex = courseList.value.data?.coursesData?.indexWhere((e) => e.id == firstEnrollment.levelId) ?? -1;
          selectedLevel.value = (levelIndex != -1) ? courseList.value.data!.coursesData![levelIndex] : SingleCourse();
        } else {
          selectedLevel.value = SingleCourse();
        }
      }

      // Enrollment Date
      selectedMonth.value = firstEnrollment.startDate != null ? getFormattedMonthFromDate(firstEnrollment.startDate.toString()) : "";
      selectedYear.value = firstEnrollment.startDate != null ? getYearFromDate(firstEnrollment.startDate.toString()) : "";
    } else {
      destinationCountry.value = SingleCountry();
      selectedUniversity.value = SingleUniversity();
      selectedLevel.value = SingleCourse();
    }

    // Other Details
    selectedRange.value = lead.value.tutionFeeInfoApp ?? "";
    isSelfReferring.value = (lead.value.referringApp ?? "").toLowerCase() == "yes";
    hasVisaRefusal.value = lead.value.hasVisaRefusal == 1;
  }


  void updateStudent() async {
    if (isAccepted.value) {
      isUpdating.value = true;
      var endPoint = APIEndPoints.updateLead;
      var body = getStudentFormBody();
      body["lead_id"] = lead.value.id.toString();

      if (emailController.text != lead.value.email) {
        await checkEmail().then((value) async {
          if (value) {
            completeUpdate(endPoint: endPoint, body: body);
          } else {
            isUpdating.value = false;
          }
        });
      } else {
        completeUpdate(endPoint: endPoint, body: body);
      }
    } else {
      CustomSnackBar(
              msg:
                  "You have to agree with Admission Group terms and condition first.",
              isSuccess: false)
          .showSnackBar();
    }
  }

  Future<void> completeUpdate({
    required String endPoint,
    required Map<String, dynamic> body,
  }) async
  {
    try {
      var value =
          await RemoteServices.postRequest(endPoint: endPoint, body: body);

      if (value != null) {
        Get.put(LeadListController()).getLeadListData();
        Get.find<LeadListController>().getEstimatedIncome();
        nextStep();
      } else {
        CustomSnackBar(msg: APIEndPoints.httpErrorMSG.value, isSuccess: false)
            .showSnackBar();
      }
    } catch (e) {
      CustomSnackBar(
              msg: "An error occurred: ${e.toString()}", isSuccess: false)
          .showSnackBar();
    } finally {
      isUpdating.value = false; // Ensure state resets in all cases
    }
  }

  void resetFields() {
    // Reset observable lead object
    lead.value = SingleLead();

    // Reset form state variables
    currentStep.value = 0;
    isUpdateForm.value = false;
    isLoading.value = false;
    isEmailExist.value = true;
    isAccepted.value = false;
    isUpdating.value = false;

    // Reset text controllers
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();
    countryNameController.clear();
    countryCodeController.clear();
    notesController.clear();

    // Reset selected dropdown values
    selectedGender.value = "";
    selectedCountry.value = SingleCountry();
    destinationCountry.value = SingleCountry();
    selectedPhoneCountry.value = SingleCountry();
    selectedUniversity.value = SingleUniversity();
    selectedLevel.value = SingleCourse();
    selectedMonth.value = "";
    selectedYear.value = "";
    selectedRange.value = "";

    // Reset lists (countries, universities, and courses)
    countryList.clear();
    destinationCountryList.clear();
    universityList.value = UniversityListModel();
    courseList.value = LevelListModel();

    // Reset boolean flags
   // isSelfReferring.value = true;
    hasVisaRefusal.value = false;

    // Reset file lists
    cvFile.clear();
    passportFile.clear();
    additionalFiles.clear();
    academicFile.clear();

    // Reset uploaded files
    uploadedCVFile.clear();
    uploadedAcademicFile.clear();
    uploadedPassportFile.clear();
    uploadedAdditionalFiles.clear();

    // Reset uploaded documents
    uploadedDocuments.value = AdditionalFileListModel();

    // Reset upload progress tracking
    uploadProgress.clear();

    // Reset lead ID and available years list
    leadId.value = "";
  }





  Map<String, dynamic> getStudentFormBody() {
    return {
      "mobile":
          "+${selectedPhoneCountry.value.callingCode}${phoneController.text}",
      "given_name": firstNameController.text,
      "family_name": lastNameController.text,
      "email": emailController.text,
      "gender": selectedGender.value.isEmpty ? "" : selectedGender.value,
      "nationalities_id": selectedCountry.value.id.toString(),
      "mobile_country_id": selectedPhoneCountry.value.id.toString(),
      "notes": notesController.text,
      "start_date":
          getFormattedDateFromMonth(selectedMonth.value, selectedYear.value),
      "level_id": selectedLevel.value.id.toString(),
      "university_id": selectedUniversity.value.id.toString(),
      "tution_fee_info": selectedRange.value,
      "referring": isSelfReferring.value ? "yes" : "no",
      "has_visa_refusal": hasVisaRefusal.value ? "1" : "0",
      "destination_id": destinationCountry.value.id.toString(),
      "tution_fee_info_concat": "Tuition Fee: ${selectedRange.value}",
      "referring_app_concat":
          "Referring: ${isSelfReferring.value ? "Self" : "Other"}",
    };
  }

  void filePreview(File file) {
    String fileExtension =
        p.extension(file.path).toLowerCase().replaceFirst('.', '');
    Get.put(FilePreviewController());
    Get.find<FilePreviewController>().fileUrl.value = file.path;
    Get.find<FilePreviewController>().fileType.value = fileExtension;
    Get.find<FilePreviewController>().isLocalFile.value = true;
    Get.find<FilePreviewController>().loadFile();
    Get.toNamed(Routes.FILE_PREVIEW);
  }

  void selectImage(
      {required ImageSource source, required String fileType}) async
  {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      // Process the image (e.g., save or display it)
      if (fileType == "Academic") academicFile.add(File(pickedFile.path));
      if (fileType == "CV") cvFile.add(File(pickedFile.path));
      if (fileType == "Passport") passportFile.add(File(pickedFile.path));
      if (fileType == "Additional") additionalFiles.add(File(pickedFile.path));
    }
  }

  void handleDocumentSelection(
      {required String fileType, required isMultiple}) async
  {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: isMultiple);
    if (result != null) {
      for (var file in result.files) {
        if (fileType == "Academic") academicFile.add(File(file.path ?? ""));
        if (fileType == "CV") cvFile.add(File(file.path ?? ""));
        if (fileType == "Passport") passportFile.add(File(file.path ?? ""));
        if (fileType == "Additional") {
          additionalFiles.add(File(file.path ?? ""));
        }
      }
    }
  }

  void uploadFile() async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.uploadLeadAdditionalFile;
    try {
      var response = await RemoteServices.uploadFiles(
          leadId: isUpdateForm.value ? "${lead.value.id}" : leadId.value,
          documentFiles: additionalFiles,
          fileNames: getFileNames(additionalFiles),
          cvFile: cvFile.isNotEmpty ? cvFile.first : null,
          passportFile: passportFile.isNotEmpty ? passportFile.first : null,
          academicFile: academicFile.isNotEmpty ? academicFile.first : null,
          endPoint: endPoint,
          requestType: "POST");
      if (response != null) {
        nextStep();
      }else{
        CustomSnackBar(
          isSuccess: false,
          msg: APIEndPoints.httpErrorMSG.value
        ).showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }
  }

  List<String> getFileNames(List<File> files) {
    return files.map((file) => file.path.split('/').last).toList();
  }

  void getPrimaryData() async {
    await getCountryList();
    await getDestinationCountries().then((value){
     if(isUpdateForm.value) preLoadData();
      getAdditionalFiles(leadId: lead.value.id.toString());
    });

    /*await getUniversityList().then((value) async {
      await getCoursesList().then((value) {
        if (isUpdateForm.value) {
          preLoadData();
          getAdditionalFiles(leadId: lead.value.id.toString());
        }
      });
    });*/
  }

  Future<void> getAdditionalFiles({required String leadId}) async {
    uploadedCVFile.value = [];
    uploadedPassportFile.value = [];
    uploadedAcademicFile.value = [];
    uploadedAdditionalFiles.value = [];
    isUpdating.value = true;
    var endPoint = APIEndPoints.getLeadAdditionalFile;
    var parameters = {
      "lead_id": leadId,
    };
    try {
      var response = await RemoteServices.getRequest(
          endPoint: endPoint, parameters: parameters);
      if (response != null) {
        uploadedDocuments.value = AdditionalFileListModel.fromJson(response);
        if (uploadedDocuments.value.data?.cv?.id != null) {
          uploadedCVFile.add(uploadedDocuments.value.data?.cv ?? SingleFile());
        }
        if (uploadedDocuments.value.data?.passport?.id != null) {
          uploadedPassportFile
              .add(uploadedDocuments.value.data?.passport ?? SingleFile());
        }if (uploadedDocuments.value.data?.academicDoc?.id != null) {
          uploadedAcademicFile
              .add(uploadedDocuments.value.data?.academicDoc ?? SingleFile());
        }
        uploadedAdditionalFiles.value =
            uploadedDocuments.value.data?.fileList?.data ?? [];
      }
    } finally {
      isUpdating.value = false;
    }
  }

  void renameUploadedDocument({int? id, required String newName}) async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.renameDocument;
    var body = {"id": id.toString(), "file_name": newName};

    try {
      var response =
          await RemoteServices.postRequest(endPoint: endPoint, body: body);
      if (response != null) {
        await getAdditionalFiles(leadId: lead.value.id.toString());
        CustomSnackBar(isSuccess: true, msg: response["msg"]).showSnackBar();
      }
    } finally {
      isUpdating.value = false;
    }
  }

  String getAdditionalNotesValue(String text) {
    RegExp regExp = RegExp(r"Additional Notes:\s*(.*)", multiLine: true);
    Match? match = regExp.firstMatch(text);

    return match?.group(1)?.trim() ?? "";
  }

  List<String> getUpcomingYears({int count = 5}) {
    int currentYear = DateTime.now().year;
    return List.generate(count, (index) => (currentYear + index).toString());

  }

  void removeUploadedFile(SingleFile file) async {
    isUpdating.value = true;
    var endPoint = APIEndPoints.deleteDocument;
    var parameters={
      "id":file.id.toString()
    };
    var response = await RemoteServices.getRequest(endPoint: endPoint,parameters: parameters);

    if (response != null) {
      print(response);
      getAdditionalFiles(
          leadId: isUpdateForm.value
              ? lead.value.id.toString()
              : leadId.value.toString());
    }
  }

  Future<void>getDestinationCountries()async{
    isLoading.value = true;
    var endPoint = APIEndPoints.destinationCountries;
    try {
      var response = await RemoteServices.getRequest(endPoint: endPoint);
      if (response != null) {
        var countryListModel=CountryListModel.fromJson(response);
        destinationCountryList.value = countryListModel.data??[];
      }
    } finally {
      isLoading.value = false;
    }
  }
}
