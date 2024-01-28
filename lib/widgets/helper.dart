import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'addsize.dart';
import 'apptheme.dart';


class Helpers {
  late BuildContext context;
  late DateTime currentBackPressTime;

  Helpers.of(BuildContext _context) {
    context = _context;
  }

  static OverlayEntry overlayLoaderProgress(context,
      {required RxString progress, required text}) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: AppTheme.primaryColor.withOpacity(0.02),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AddSize.size40, vertical: AddSize.size40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoActivityIndicator(
                          radius: AddSize.size30,
                          color: AppTheme.primaryColor,
                        ),
                        SizedBox(
                          height: AddSize.size16,
                        ),
                        /* Obx(() {
                          return Center(
                            child: AddText(
                              text: "${progress.value}%",
                              fontWeight: FontWeight.bold,
                              fontSize: AddSize.font18,
                              color: Colors.black,
                            ),
                          );
                        }),*/
                        SizedBox(
                          height: AddSize.size16,
                        ),
                        // Text(
                        //   text: text,
                        //   fontSize: AddSize.font16,
                        //   fontWeight: FontWeight.bold,
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
    return loader;
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: AppTheme.primaryColor.withOpacity(0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.threeArchedCircle(
                  color: AppTheme.primaryColor, size: AddSize.size40),
            ],
          ),
        ),
      );
    });
    return loader;
  }

  static OverlayEntry overlayLoaderWithAnimation(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: AppTheme.primaryColor.withOpacity(0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.threeArchedCircle(
                  color: AppTheme.primaryColor, size: AddSize.size40),
            ],
          ),
        ),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(const Duration(milliseconds: 500), () {
      try {
        loader.remove();
        // ignore: empty_catches
      } catch (e) {}
    });
  }

  static createSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.black,
      content: Text(
        message,
        style: const TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    ));
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return (!regex.hasMatch(value)) ? false : true;
  }
}
