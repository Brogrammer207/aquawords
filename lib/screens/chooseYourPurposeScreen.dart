import 'dart:io';
import 'package:aquawords/screens/homePageScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../widget/helper.dart';
import '../widgets/customtextformfield.dart';

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Rx<File> image = File("").obs;
  Rx<File> categoryFile = File("").obs;
  String? categoryValue;

  Future<void> uploadImage() async {
    try {
      OverlayEntry loader = Helper.overlayLoader(context);
      Overlay.of(context).insert(loader);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String imageName = 'profile_image_$userId.png';

      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$imageName');

      UploadTask uploadTask = storageReference.putFile(categoryFile.value);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Save the download URL in Firestore
      await FirebaseFirestore.instance.collection('Profile').doc(userId).set({
        'image': downloadUrl,
        'name': nameController.text.trim(),
      });

      Get.to(const HomePageScreen());
      Helper.hideLoader(loader);
    } catch (e) {
      // Handle the error
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    showActionSheet(context);
                  },
                  child: categoryFile.value.path != ""
                      ? Obx(() {
                          return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(11),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(
                                        0.2,
                                        0.2,
                                      ),
                                      blurRadius: 1,
                                    ),
                                  ]),
                              height: 150,
                              width: 150,
                              child: Image.file(
                                categoryFile.value,
                              ));
                        })
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(11),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(
                                    0.2,
                                    0.2,
                                  ),
                                  blurRadius: 1,
                                ),
                              ]),
                          height: 150,
                          width: 150,
                          child: const Icon(
                            Icons.person,
                            size: 100,
                          ))),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Add Profile Photo',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff132137),
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: RegisterTextFieldWidget(
                  controller: nameController,
                  hint: 'Enter Your Name',
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Please enter your Name'),
                  ]).call,
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: CommonButtonBlue(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      uploadImage();
                    }
                  },
                  title: 'Next',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Select Picture from',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(
                      imageSource: ImageSource.camera, imageQuality: 30)
                  .then((value) async {
                if (value != null) {
                  categoryFile.value = File(value.path);
                  setState(() {});
                }
                Get.back();
              });
            },
            child: const Text("Camera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(
                      imageSource: ImageSource.gallery, imageQuality: 30)
                  .then((value) async {
                if (value != null) {
                  categoryFile.value = File(value.path);
                  setState(() {});
                }
                Get.back();
              });
            },
            child: const Text('Gallery'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
