import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contacts/constant.dart';

import '../controllers/app_controller.dart';
import 'package:http/http.dart' as http;
final AppController controller = Get.find();

class ApiService {
  static var client = http.Client();
  static const baseUrl="http://146.59.52.68:11235";
  static var header = {'Content-Type': 'application/json', 'ApiKey': ' e781d9aa-d113-44e5-ae09-5b6bb743ba0d','accept': 'text/plain'};

  static Future<void> submitData(body) async {
    const postUrl =baseUrl;
    final response = await client.post(Uri.parse(baseUrl+"/api/User"), body: jsonEncode(body), headers: header);
    print(response.statusCode);
    if (response.statusCode == 200) {

      // controller.successMessage('User added');
      Get.showSnackbar(
        GetSnackBar(
          message: 'User added!',
          backgroundColor: white,
          messageText: Text(
            'User added!',
            style: TextStyle(color:green),
          ),
          icon: Icon(Icons.check_circle,color: green,),
          duration: Duration(seconds: 2),
          borderRadius: 12,
        ),
      );


      controller.disposeControllers();
    } else {
      controller.errorMessage('Failed to add user');
    }
    // print(response.statusCode);
    // print(response.body);
  }

  static Future<void> updateData(body, String id) async {
    final updateUrl = 'http://146.59.52.68:11235/api/User/$id';
    print("object");
    print(Uri.parse(updateUrl).toString()+"131321321");
    final response = await client.put(Uri.parse(updateUrl),
        body: jsonEncode(body), headers: header);
    if (response.statusCode == 200) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Changes have been applied!',
          backgroundColor: white,
          messageText: Text(
            'Changes have been applied!',
            style: TextStyle(color:green),
          ),
          icon: Icon(Icons.check_circle,color: green,),
          duration: Duration(seconds: 2),
          borderRadius: 12,
        ),
      );
    } else {
      controller.errorMessage('Failed to updated');
      // print(response.body);
    }
  }
}