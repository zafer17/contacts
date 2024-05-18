
import 'package:contacts/views/widgets/contactsCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/app_controller.dart';
import 'dart:io';
import 'package:contacts/constant.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final AppController controller = Get.put(AppController());
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
     // controller.imageController.text=_image as String;
      controller.checkFields(_image);
    }
  }

  Future<void> captureImageWithCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
    controller.checkFields(_image);
  }

  void _showNewContactBottomSheet() {

    // Get reference to the controller
    //_image=null;
    final controller = Get.find<AppController>();
    controller.firstNameController.clear();
    controller.lastNameController.clear();
    controller.phoneNumberControlller.clear();

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final double screenHeight = MediaQuery.of(context).size.height;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.95,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancel"),
                      ),
                      Text(
                        "New Contact",
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      TextButton(

                        onPressed: controller.allFieldsFilled.value
                            ? () {


                         // controller.uploadImage(_image!);

                          controller.addContact(_image!);
                          _image=null;
                          controller.fetchContacts(controller.searchController.text);
                          Get.back();

                        }
                            : null,
                        child: const Text("Done"),
                      )
                    ],
                  ),
                  _image != null
                      ? CircleAvatar(
                    radius: 72.5,
                    backgroundImage: FileImage(_image!),
                  )
                      : const Icon(Icons.person_2_sharp, size: 145),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Gallery'),
                                  onTap: () {
                                    pickImageFromGallery();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Camera'),
                                  onTap: () {
                                    captureImageWithCamera();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title: const Text('Cancel'),
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child:  Text(
                      "Add Photo",
                      style: TextStyle(color: black),
                    ),
                  ),
                  TextField(
                    maxLines: 1,
                    controller: controller.firstNameController,
                    onChanged: (_) => controller.checkFields(_image),
                    decoration: const InputDecoration(hintText: "First Name"),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextField(
                    maxLines: 1,
                    controller: controller.lastNameController,
                    onChanged: (_) => controller.checkFields(_image),
                    decoration: const InputDecoration(hintText: 'Last Name'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextField(
                    maxLines: 1,
                    controller: controller.phoneNumberControlller,
                    onChanged: (_) => controller.checkFields(_image),
                    decoration: const InputDecoration(hintText: "Phone Number"),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: page_color,
      appBar: AppBar(
        backgroundColor: page_color,
        title:  Text('Contacts',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            onPressed: () {
              _showNewContactBottomSheet();
              // _image=null;
            },
            icon:  Icon(
              Icons.add_circle,
              color: blue,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                width:screenWidth*0.85,
                height: screenHeight*0.042,
                child: TextField(
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 13),
                    hintText: 'Search by name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: white),
                        borderRadius: BorderRadius.circular(12.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: white),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: white,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (query) {
                    // controller.filterContacts(query);
                    controller.searchController.text=query;
                    controller.fetchContacts(query);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Visibility(
        visible: controller.userModel!.users.isNotEmpty,
        replacement:  Center(
            child: Column(
              children: [
                SizedBox(height: screenHeight*0.15,),
                Icon(Icons.person_2_sharp, size: 100),
                Text('No Contacts', style: TextStyle(fontSize: 23)),
                Text('Contacts you’ve added will appear here.', style: TextStyle(fontSize: 14)),
                TextButton(onPressed:(){
                    _showNewContactBottomSheet();
                } ,
                  child:   Text('Create New Contact', style: TextStyle(fontSize: 14,color: blue,fontWeight: FontWeight.bold)),)

              ],
            )),
        child: Row(
          children: [
            SizedBox(width: screenWidth*0.050,),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.userModel!.users.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width:screenWidth*0.85,
                        height: screenHeight*0.075,
                        child: ContactWidget(index: index)),
                  );
                },
              ),
            ),
            SizedBox(width: screenWidth*0.050,),

          ],
          //child:
        ),
      )),
    );
  }
}
