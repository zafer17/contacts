import 'dart:convert';
import 'package:contacts/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
class AppController extends GetxController {
  var isLoading = true.obs;
  var editPage = true.obs;
 static var header = {'accept': 'text/plain','ApiKey': 'e781d9aa-d113-44e5-ae09-5b6bb743ba0d'};

  UserModel? userModel;
  List filteredList=RxList();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberControlller=TextEditingController();
  TextEditingController imageController=TextEditingController();

  TextEditingController searchController = TextEditingController();


  var allFieldsFilled = false.obs;
  void checkFields(File? image) {
    allFieldsFilled.value = firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        phoneNumberControlller.text.isNotEmpty &&
        (image != null);
  }
  @override
  void onClose() {
    // Dispose text editing controllers when the controller is closed
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberControlller.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    fetchContacts(searchController.text);

    super.onInit();
  }

  Future<void>fetchContacts( String searchQuery ) async {
    String a='';

    try {
      isLoading(true);
      if(searchQuery.isEmpty){
        searchQuery="";
      }
      final Uri uri = Uri.parse('${ApiService.baseUrl}/api/User').replace(
        queryParameters: {
          if (searchQuery.isNotEmpty) 'search': searchQuery,
          'take':"100",

        },
      );
      var response = await ApiService.client.get(uri,headers: header);
      print(response);
      if (response.statusCode == 200) {
        print("zafer");
        var jsonString = jsonDecode(response.body);
        userModel = UserModel.fromJson(jsonString);
        update();
      }
    } finally {
      isLoading(false);
    }
    return null;
  }

  Future<void> deleteById(id) async {
    final deleteUrl = 'http://146.59.52.68:11235/api/User/$id';
    print(deleteUrl);
    final uri = Uri.parse(deleteUrl);
    print(uri);
    final response = await ApiService.client.delete(uri,headers: header);
    print(response.statusCode);
    if (response.statusCode == 200) {
      fetchContacts(searchController.text);
      //update();
    } else {}
    Get.back();

  }


  Future<void> updateContact( String id,File? image,String url) async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final phoneNumber = phoneNumberControlller.text;
    var imageUrl=url;
    if(image!=null)
      {
        imageUrl = await uploadImage(image);
      }


    final body = {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "profileImageUrl":imageUrl
    };

    ApiService.updateData(body, id);
    Get.back();
    fetchContacts(searchController.text);
    update();
   disposeControllers();
  }

  void successMessage(String message) {
    Get.snackbar("Success", message, snackPosition: SnackPosition.BOTTOM);
  }

  void errorMessage(String message) {
    Get.snackbar("Failed", message);
  }

  void disposeControllers() {
    firstNameController.clear();
    lastNameController.clear();
    phoneNumberControlller.clear();
  }

  // Future void addContact(String )

  Future<void> addContact(File image) async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final phoneNumber = phoneNumberControlller.text;
    final imageUrl= await uploadImage(image);

    final body = {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "profileImageUrl":imageUrl,
    };
    ApiService.submitData(body);

    fetchContacts(searchController.text);
    update();
    disposeControllers();
    allFieldsFilled=false.obs;
  }
  Future<String> uploadImage(File imageFile) async {
    var request = http.MultipartRequest('POST',Uri.parse("http://146.59.52.68:11235/api/User/UploadImage"));
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      var responseBody=json.decode(response.body);
      String imageUrl=responseBody["data"]["imageUrl"];
      imageController.text=imageUrl;
      return imageUrl;

      print('Yükleme yanıtı: ${response.body.isImageFileName.toString()}');
    } else {
      // Yükleme başarısız oldu, hata mesajını işleyin.
      print('Hata mesajı: ${response.body}');
      return "";
    }
  }

}
