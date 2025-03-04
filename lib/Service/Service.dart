import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../myColors.dart';

class CustomDesign {

  static void snackbar(String message, {String title = "Opps!"})
  {
    Get.snackbar(
      title, // Empty title to hide default text
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent, // Make background transparent
      duration: const Duration(seconds: 3),
      borderRadius: 10,
      titleText: Text(title,style: TextStyle(color: MyColors.white,fontSize: 20.sp),),
      messageText: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: Colors.white70,
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 2
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showProgressDialog({String message = "Updating profile..."}) {
    Get.dialog(
      AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.green, // Replace with MyColors.green if defined
              strokeWidth: 2,
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Text(
                message,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false, // Prevent dialog from being closed manually
    );
  }

  static void hideProgressDialog() {
    if (Get.isDialogOpen!) {
      Get.back(); // Close the dialog
    }
  }
}

