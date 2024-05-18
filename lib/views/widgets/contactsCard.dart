
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:contacts/constant.dart';
import '../../controllers/app_controller.dart';

class ContactWidget extends StatelessWidget {
  int index;
   AppController controller = Get.find();

  ContactWidget({
    Key? key,
    required this.index,
  }) : super(key: key);
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // Perform operations with the selected image file
    }
  }

  Future<void> captureImageWithCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      //controller.uploadImage(_image!);
      // Perform operations with the captured image file
    }
  }
  @override
  Widget build(BuildContext context) {
    void _showEditContactBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          var screenHeight=MediaQuery.of(context).size.height;
          var screenWidth=MediaQuery.of(context).size.width;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.90,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: (){
                          Get.back();
                        },
                            child: const Text("Cancel",style: TextStyle(fontWeight: FontWeight.bold))),
                         //Text("Edit Contact",style:TextStyle(color: black,fontWeight: FontWeight.bold,fontSize: 24),),
                        TextButton(onPressed: (){
                          if(_image==null)
                            {
                             // controller.uploadImage(_image!);

                              // _image=null;
                            }
                          controller.imageController.text;

                          controller.updateContact(


                               controller.userModel!.users[index].id,
                            _image,
                            controller.userModel!.users[index].profileImageUrl

                          );
                         // controller.updateProfileImage(index, _image!);
                          controller.fetchContacts(controller.searchController.text);
                          Get.back();
                        },
                            child: const Text("Edit",style: TextStyle(fontWeight: FontWeight.bold),)
                        )
                      ],
                    ),
                    //const Icon(Icons.person_2_sharp,size: 145,),
                    _image==null?
                        ClipOval(
                          child: Image.network(
                            controller.userModel!.users[index].profileImageUrl,
                            height: screenHeight*0.15,
                            width: screenWidth*0.33,
                            fit: BoxFit.cover,

                          ),
                        ):CircleAvatar(
                      radius: 72.5,
                      backgroundImage: FileImage(_image!),
                    ),
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
                        "Change Photo",
                        style: TextStyle(color: black),
                      ),
                    ),
                    TextField(

                      controller: controller.firstNameController,
                      decoration: const InputDecoration(hintText: "First Name",),),
                     SizedBox(height: screenHeight*0.02),
                    TextField(
                        maxLines: 1,
                        controller: controller.lastNameController,
                        decoration: const InputDecoration(hintText: 'Last Name')),
                     SizedBox(height: screenHeight*0.02),
                    TextField(
                      controller: controller.phoneNumberControlller,
                      decoration: const InputDecoration(hintText: "Phone Number",),),
                     SizedBox(height: screenHeight*0.02),
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
                                    title: Center(
                                      child: Text(
                                        'Delete Account?',
                                        style: TextStyle(color: red_delete_account,fontWeight: FontWeight.bold,fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: const Center(
                                      child: Text('Yes'),
                                    ),
                                    onTap: () {
                                      controller.deleteById(controller.userModel!.users[index].id);
                                      Get.back();
                                    },
                                  ),
                                  ListTile(
                                    title: const Center(
                                      child: Text('No'),
                                    ),
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
                      //controller.deleteById(controller.userModel!.users[index].id);


                        child:Text("Delete Account",style: TextStyle(color:red_delete_account),))

                  ],
                )
            ),
          );
        },

      );

    }
    return InkWell(
      onTap: (){
        var firstName = controller.userModel!.users[index].firstName;
        var lastName = controller.userModel!.users[index].lastName;
        var phoneNumber = controller.userModel!.users[index].phoneNumber;
        controller.firstNameController.text = firstName!;
        controller.lastNameController.text = lastName!;
        controller.phoneNumberControlller.text = phoneNumber!;
        _showEditContactBottomSheet();
      },
      child: Container(


        //margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
          color: white,
            border: Border.all(color: white, width: 1),
            borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(controller.userModel!.users[index].profileImageUrl),
          ),

          title: Text(controller.userModel!.users[index].firstName+" "+controller.userModel!.users[index].lastName,
              style:  TextStyle(
                  color: black, fontWeight: FontWeight.w600)),
          subtitle: Text(controller.userModel!.users[index].phoneNumber,
              style:  TextStyle(color: black)),

        ),
      ),
    );

    //   ListTile(
    //   title: Text(controller.toDoModel!.items[index].description),
    // );
  }
}