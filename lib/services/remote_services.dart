import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../app/modules/registration/models/country_list_model.dart';
import '../constraints/api_end_points.dart';
import 'local_services.dart';


class RemoteServices {
  static var clint = http.Client();
  static var baseURL = APIEndPoints.baseURL;

  static var token = "";

  //http post request
  static Future<dynamic> postRequest(
      {required String endPoint, Map<dynamic, dynamic>? body}) async {
    token = await LocalServices.getToken() ?? "";

    if (kDebugMode) {
      print(token);
    }
    var uri = Uri.parse(baseURL + endPoint);
    var requestBody = body;
    var requestHeader = {"Authorization": "Bearer $token"};

    if (kDebugMode) {
      print(baseURL + endPoint);
      print(body);

    }
    try {
      http.Response response = await http.post(
        uri,
        body: requestBody,
        headers: requestHeader,
      );
      // print(body);
      if (kDebugMode) {
        print(response.body);
        print("Code: ${response.statusCode}");
      }
        var r = json.decode(response.body);
        if (kDebugMode) {
          print(response.body);
          print("Code: ${response.statusCode}");
        }

        if (r["status"] ?? false) {
          if (kDebugMode) {
            print(r["msg"]);
            print(r);
          }
          return r;
        }
        else {
          String message = r.toString().contains("msg")
              ? r["msg"]
              : "Something went wrong. Please try again later.";
          if (kDebugMode) {
            print(r["msg"]);
          }
          APIEndPoints.httpErrorMSG.value = message;
          return null;
        }

    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
        APIEndPoints.httpErrorMSG.value ="Something went wrong. Please try again later.";
      }
      return null;
    }
  }

  //http post request with Json Data
  static Future<dynamic> postRequestWithJsonData(
      {required String endPoint, Map<dynamic, dynamic>? body}) async {
    //var uri = Uri.parse(baseURL+endPoint);
    token = await LocalServices.getToken() ?? "";
    var uri = Uri.parse(baseURL + endPoint);
    var requestBody = body;
    var requestHeader = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    };
    if (kDebugMode) {
      print(baseURL + endPoint);
    }
    try {
      http.Response response = await http.post(uri,
          body: json.encode(requestBody),
          headers: requestHeader,
          encoding: Encoding.getByName("utf-8"));
      var r = json.decode(response.body);

      if (r["status"] ?? true) {
        if (kDebugMode) {
          print(r["msg"]);
        }
        return r;
      } else {
        String message = r.toString().contains("msg") ? r["msg"] : "";
        APIEndPoints.httpErrorMSG.value = message;
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  //http post request with Direct link
  static Future<dynamic> postRequestWithFullLink({required String url}) async {
    token = await LocalServices.getToken() ?? "";
    var requestHeader = {"Authorization": "Bearer $token"};
    try {
      var uri = Uri.parse(url);
      if (kDebugMode) {
        print(url);
      }
      http.Response response = await http.post(uri, headers: requestHeader);
      //print("Response:   ${response.body}");
      var r = json.decode(response.body);

      if (r["status"]) {
        return r;
      } else {
        String message = r.toString().contains("msg") ? r["msg"] : "";
        APIEndPoints.httpErrorMSG.value = message;
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  //http get request
  static Future<dynamic> getRequest(
      {required String endPoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? parameters}) async {
    // var response=await clint.get(Uri.parse(baseURL+endPoint),headers:header);

    token = await LocalServices.getToken() ?? "";
    if (kDebugMode) {
      print("Token: $token");
      print(baseURL+endPoint);
    }
    var headers = {"Authorization": "Bearer $token"};
    try {
      var response = await clint.get(
          Uri.parse(baseURL + endPoint).replace(queryParameters: parameters),
          headers: headers);
      var r = json.decode(response.body);

      if (kDebugMode) {
        print(
            Uri.parse(baseURL + endPoint).replace(queryParameters: parameters));
        print(response.body);
      }

      if (r["status"] ?? false) {
        return r;
      } else {
        String message = r.toString().contains("msg") ? r["msg"] : "";
        APIEndPoints.httpErrorMSG.value = message;
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  //http get request with full Link
  static Future<dynamic> getRequestLoadMore(
      {required String url, Map<String, dynamic>? body}) async
  {
    // var response=await clint.get(Uri.parse(baseURL+endPoint),headers:header);
    token = await LocalServices.getToken() ?? "";
    var headers = {"Authorization": "Bearer $token"};

    try {
      var response = await clint.get(Uri.parse(url), headers: headers);
      var r = json.decode(response.body);

      if (kDebugMode) {
        print(url);
        print(response.body);
      }
      if (r["status"]) {
        return r;
      } else {
        String message = r.toString().contains("msg") ? r["msg"] : "";
        APIEndPoints.httpErrorMSG.value = message;
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }


  static Future<List<SingleCountry>> getCountryList() async {
    try {
      // Try to get the stored country list from local storage
      var storedData = await LocalServices.getCountryList();

      if (storedData != null && storedData.data != null && storedData.data!.isNotEmpty) {
        return storedData.data!;
      }

      // If local storage is empty, fetch data from API
      return await _fetchAndStoreCountryList();
    } catch (e) {
      // If an error occurs, try fetching from API as a fallback
      return await _fetchAndStoreCountryList();
    }
  }


// Helper function to fetch and store country list from API
  static Future<List<SingleCountry>> _fetchAndStoreCountryList() async {
    var endPoint = APIEndPoints.countryList;
    var response = await getRequest(endPoint: endPoint);

    if (response != null) {
      var countryListModel = CountryListModel.fromJson(response);
      await LocalServices.storeCountryList(countryListModel);
      return countryListModel.data ?? [];
    }

    return []; // Return an empty list if API call fails
  }


  static Future<dynamic> uploadImages({
    File? image,
    required String endPoint,
    Map<String, String>? body,
  }) async {
    var uri = Uri.parse(baseURL + endPoint);
    var headers = {"Authorization": "Bearer $token"};
    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);
      request.fields.addAll(body ?? {});

      // If there's an image, add it to the request
      if (image != null && image.existsSync()) {
        var fileStream = http.ByteStream(image.openRead());
        var length = await image.length();
        var multipartFile = http.MultipartFile(
          'file',
          fileStream,
          length,
          filename: image.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      var response = await http.Response.fromStream(await request.send());
      var r = json.decode(response.body);
      if (response.statusCode == 200) {
        // Upload successful
        if (kDebugMode) {
          print('Upload successful');
        }
        return r;
      } else {
        String message = r.toString().contains("msg") ? r["msg"] : "";
        APIEndPoints.httpErrorMSG.value = message;
        if (kDebugMode) {
          print(message);
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }



  static Future<dynamic> uploadSingleFile({
    required String filePath,
    required String fieldName,
    required String endPoint,
    required String requestType,
    Map<String, String>? body,
  }) async
  {
    final Uri uri = Uri.parse(baseURL + endPoint);
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print(uri);
      print(body);
      print(filePath);
      print(fieldName);
    }

    try {
      final http.MultipartRequest request = http.MultipartRequest(requestType, uri);

      request.headers.addAll(headers);
      request.fields.addAll(body ?? {});

      // Add files to the request
        if (filePath.isNotEmpty) {
          request.files.add(
            await http.MultipartFile.fromPath(
              fieldName, // field name in the request
              filePath, // path of the file
            ),
          );
        }


      final response = await http.Response.fromStream(await request.send());
      var r = json.decode(response.body);
      if (response.statusCode == 200) {
        // Upload successful
        if (kDebugMode) {
          print('Images uploaded successfully');
        }
        return r;
      } else {
        String message = r.toString().contains("msg") ? r["msg"] : "";
        APIEndPoints.httpErrorMSG.value = message;
        if (kDebugMode) {
          print(message);
        }
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }



/*  static Future<dynamic> uploadMultipleFiles({
    required List<String> filePaths,
    required String fieldName, // Field name for each file
    required String endPoint,
    required String requestType,
    Map<String, String>? body,
  }) async {
    final Uri uri = Uri.parse(baseURL + endPoint);
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print(uri);
      print(body);
      print(filePaths);
      print(fieldName);
    }

    try {
      final http.MultipartRequest request = http.MultipartRequest(requestType, uri);

      request.headers.addAll(headers);
      request.fields.addAll(body ?? {});

      // Add files to the request
      for (String filePath in filePaths) {
        if (filePath.isNotEmpty) {
          request.files.add(
            await http.MultipartFile.fromPath(
              fieldName, // Field name in the request
              filePath, // Path of the file
            ),
          );
        }
      }

      final response = await http.Response.fromStream(await request.send());
      var r = json.decode(response.body);

      if (response.statusCode == 200) {
        // Upload successful
        if (kDebugMode) {
          print('Files uploaded successfully');
        }
        return r;
      } else {
        String message = r.toString().contains("msg") ? r["msg"] : "";
        APIEndPoints.httpErrorMSG.value = message;
        if (kDebugMode) {
          print(message);
        }
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }*/


  static Future<dynamic> uploadMultipleFiles({
    required List<Map<String, dynamic>> selectedDocument, // List of file details
    required String endPoint,
    required String requestType,
    required String leadId, // Lead ID to be sent
  }) async
  {
    final Uri uri = Uri.parse(baseURL + endPoint);
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print(uri);
      print(selectedDocument);
      print(leadId);
    }

    try {
      final http.MultipartRequest request = http.MultipartRequest(requestType, uri);

      request.headers.addAll(headers);

      // Add lead_id to the body
      request.fields['lead_id'] = leadId;

      for (int i = 0; i < selectedDocument.length; i++) {
        final doc = selectedDocument[i];
        final filePath = doc['path'];
        final fileName = doc['name'];

        if (filePath != null && filePath.isNotEmpty) {
          // Add file name to the body with indexed key
          request.fields['file_name[$i]'] = fileName ?? 'unknown';

          // Attach the file to the request with indexed key
          request.files.add(
            await http.MultipartFile.fromPath(
              'documentfile[$i]', // Indexed field name for file
              filePath, // Path of the file
              filename: fileName, // Explicitly set the file name
            ),
          );
        }
      }

      if (kDebugMode) {
        print(request.fields); // To debug the final fields being sent
      }

      final response = await http.Response.fromStream(await request.send());
      var r = json.decode(response.body);

      if (response.statusCode == 200) {
        // Upload successful
        if (kDebugMode) {
          print('Files uploaded successfully');
        }
        return r;
      } else {
        String message = r.toString().contains("msg") ? r["msg"] : "";
        APIEndPoints.httpErrorMSG.value = message;
        if (kDebugMode) {
          print(message);
        }
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }



  static Future<dynamic> uploadFiles({
    required String leadId,
    required List<File> documentFiles, // Multiple additional files
    required List<String> fileNames, // Corresponding names for additional files
    File? cvFile, // CV Document
    File? passportFile, // Passport Document
    File? academicFile, // Passport Document
    required String endPoint,
    required String requestType,
  }) async
  {
    final Uri uri = Uri.parse(baseURL + endPoint);
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print("Uploading to: $uri");
      print("Lead ID: $leadId");
      print("Document Files: ${documentFiles.length}");
      print("CV File: ${cvFile?.path}");
      print("Passport File: ${passportFile?.path}");
      print("Academic File: ${academicFile?.path}");
    }

    try {
      final http.MultipartRequest request = http.MultipartRequest(requestType, uri);
      request.headers.addAll(headers);

      // Add lead_id
      request.fields['lead_id'] = leadId;

      // Attach multiple additional document files
      for (int i = 0; i < documentFiles.length; i++) {
        File file = documentFiles[i];
        String fileName = fileNames.length > i ? fileNames[i] : 'unknown';

        request.fields['file_name[$i]'] = fileName; // File name field
        request.files.add(
          await http.MultipartFile.fromPath(
            'documentfile[$i]', // Indexed field name for file
            file.path,
            filename: fileName,
          ),
        );
      }

      // Attach single CV file if available
      if (cvFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'cvdocumentfile',
            cvFile.path,
            filename: cvFile.path.split('/').last, // Extract filename
          ),
        );
      }

      // Attach single Passport file if available
      if (passportFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'passportdocfile',
            passportFile.path,
            filename: passportFile.path.split('/').last,
          ),
        );
      }      // Attach single Passport file if available
      if (academicFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'academic_doc',
            academicFile.path,
            filename: academicFile.path.split('/').last,
          ),
        );
      }

      if (kDebugMode) {
        print("Request Fields: ${request.fields}");
        print("Request Files: ${request.files.length}");
      }

      final response = await http.Response.fromStream(await request.send());
      var r = json.decode(response.body);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Files uploaded successfully');
        }
        return r;
      } else {
        String message = r.toString().contains("msg") ? r["msg"] : "";
        APIEndPoints.httpErrorMSG.value = message;
        if (kDebugMode) {
          print(message);
        }
        return null;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }


/*  static Future<void> uploadFiles({
    required String leadId,
    required List<File> documentFiles,
    required List<String> fileNames,
    File? cvFile,
    File? passportFile,
    required String endPoint,
    required String requestType,
    required RxMap<String, double> uploadProgress, // Progress tracking
  }) async
  {
    final Uri uri = Uri.parse(baseURL + endPoint);
    final Map<String, String> headers = {
      "Authorization": "Bearer your_token",
      "Content-Type": "multipart/form-data"
    };

    var request = http.MultipartRequest(requestType, uri);
    request.headers.addAll(headers);

    // Add leadId as a form field
    request.fields['lead_id'] = leadId;

    int totalBytes = 0;
    int uploadedBytes = 0;

    // Upload CV file
    if (cvFile != null) {
      var cvMultipartFile = await http.MultipartFile.fromPath(
        'cv', cvFile.path,
        filename: cvFile.path.split('/').last,
      );
      totalBytes += await cvFile.length(); // Ensure accurate file size
      request.files.add(cvMultipartFile);
    }

    // Upload Passport file
    if (passportFile != null) {
      var passportMultipartFile = await http.MultipartFile.fromPath(
        'passport', passportFile.path,
        filename: passportFile.path.split('/').last,
      );
      totalBytes += await passportFile.length();
      request.files.add(passportMultipartFile);
    }

    // Upload Additional Documents
    for (int i = 0; i < documentFiles.length; i++) {
      var multipartFile = await http.MultipartFile.fromPath(
        'documents[]', documentFiles[i].path,
        filename: fileNames[i], // Attach corresponding filename
      );
      totalBytes += await documentFiles[i].length();
      request.files.add(multipartFile);
    }

    // Send request and get response before listening
    var streamedResponse = await request.send();

    // Monitor progress by listening to the stream
    streamedResponse.stream.listen(
          (List<int> chunk) {
        uploadedBytes += chunk.length;
        double progress = (uploadedBytes / totalBytes);

        // Update progress for each file
        if (cvFile != null) {
          uploadProgress[cvFile.path.split('/').last] = progress;
        }
        if (passportFile != null) {
          uploadProgress[passportFile.path.split('/').last] = progress;
        }
        for (var i = 0; i < documentFiles.length; i++) {
          String fileName = fileNames[i];
          uploadProgress[fileName] = progress;
        }
      },
      onDone: () async {
        var response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200) {
          print('Upload successful');
        } else {
          print('Upload failed: ${response.body}');
        }
      },
      onError: (error) {
        print('Upload error: $error');
      },
    );
  }*/




}
