import 'package:aquawords/widgets/customtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Expanded(
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
              CommonButtonBlue(
                onPressed: () {
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
                },
                title: 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
