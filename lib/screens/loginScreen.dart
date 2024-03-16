import 'package:aquawords/widgets/customtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../widget/helper.dart';
import 'otpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String verify = "";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController phoneController = TextEditingController();
  bool value = false;
  bool showValidation = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png'),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                      child: Text(
                    "Your journey begins with a login",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )),
                  const Center(
                      child: Text(
                        "Ready to take off?",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  RegisterTextFieldWidget(
                    controller: phoneController,
                    hint: 'Enter Your Phone Number',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.1,
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: showValidation == false ? Colors.white : Colors.red),
                          child: Checkbox(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: value,
                              activeColor: const Color(0xff132137),
                              visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
                              onChanged: (newValue) {
                                setState(() {
                                  value = newValue!;
                                  setState(() {});
                                });
                              }),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                             const TextSpan(
                              text: 'Are you agree',
                              style:  TextStyle(color: Colors.black),
                            ),
                             TextSpan(
                              text: ' terms and conditions?',
                              style:  TextStyle(color: Colors.blue),
                              recognizer:  TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Data Collection Awareness'),
                                        content: Text('''User's phone number, name and image are collected in this app.
          Phone numbers are taken to allow users to login to this app, which are not shared with anyone.
              In this app, name is taken for 2 purposes. First, the name is used to set the user's profile Or the second purpose is that the functionality of this app is that any user shares images on social media and the user's name is also shared on that page.
              In this app, user image is taken for 2 purposes. First, the user image is used to set the user's profile Or the second purpose is that the functionality of this app is that any user shares images on social media and the user's image is also shared on that page.'''),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              // Perform action when the first button is pressed
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Perform action when the second button is pressed
                                              // For example, you can navigate to another screen or perform a specific task
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ); // Use your custom dialog widget here
                                    },
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonButtonBlue(
                    onPressed: () {
                      if (value == true) {
                        OverlayEntry loader = Helper.overlayLoader(context);
                        Overlay.of(context).insert(loader);
                        auth.verifyPhoneNumber(
                          phoneNumber: "${"+91"}${phoneController.text.trim()}",
                          verificationCompleted: (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {},
                          codeSent: (String verificationId, int? resendToken) {
                            LoginScreen.verify = verificationId;
                            Get.to(Otp(
                              verificationId: LoginScreen.verify,
                            ));
                            Helper.hideLoader(loader);

                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      } else {
                        showToast("Please accept term and conditions");
                      }

                    },
                    title: 'Next',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
