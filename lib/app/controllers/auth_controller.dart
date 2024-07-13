import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_automation/app/data/firebase_service.dart';
import 'package:home_automation/app/data/models/user_model.dart';
import 'package:home_automation/app/views/bottom_navigation/bottom_navigation_screen.dart';
import 'package:home_automation/common/shared_functions.dart';
import 'package:home_automation/screens/home_screen.dart';
import 'package:home_automation/utils/getx_snackbar.dart';
import 'package:home_automation/utils/logger.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  Rx<File?>? imageFile = Rx<File?>(null);
  RxBool isLoadingLogin = false.obs;
  RxBool isLoadingSignup = false.obs;
  final loginGlobalKey = GlobalKey<FormState>();
  final signupGlobalKey = GlobalKey<FormState>();

  FirebaseAuth get _auth => FirebaseAuth.instance;

  onLogin() async {
    if (!isLoadingLogin.value &&
        (loginGlobalKey.currentState?.validate() ?? false)) {
      try {
        isLoadingLogin.value = true;
        await _auth.signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());
        isLoadingLogin.value = false;
        Snack.showSuccessSnackBar("Login successfull.");
        Get.offAll(() => const BottomNavigationScreen());
      } on FirebaseAuthException catch (e, s) {
        isLoadingLogin.value = false;
        Logger.error(e, stackTrace: s);
        Snack.showErrorSnackBar(handleException(e));
      }
    }
  }

  onSignup() async {
    if (signupGlobalKey.currentState?.validate() ?? false) {
      try {
        if (imageFile?.value != null) {
          isLoadingSignup.value = true;
          await _auth.createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());
          String photoUrl = await FireBaseServices()
              .uploadPhoto(imageFile?.value ?? File(''));
          await FireBaseServices().createUser(
            UserModel(
              email: email.text.trim(),
              name: name.text.trim(),
              image: photoUrl,
            ),
          );

          isLoadingSignup.value = false;
          Get.offAll(() => const BottomNavigationScreen());
          Snack.showSuccessSnackBar("User created successfully.");
        } else {
          Snack.showInfoSnackBar("Please select image first");
        }
      } on FirebaseAuthException catch (e, s) {
        isLoadingSignup.value = false;
        Logger.error(e, stackTrace: s);
        Snack.showErrorSnackBar(handleException(e));
      }
    }
  }

  imagePick() async {
    try {
      XFile file = await pickImage() ?? XFile('');
      imageFile?.value = File(file.path);
    } catch (e) {
      Logger.error("Error while picking image.");
    }
  }

  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  String? passwordValidation(String? val) {
    if (val?.isEmpty ?? true) {
      return "Required*";
    } else if ((val?.length ?? 0) < 8) {
      return "Password should be at least 8 characters long";
    }
    return null;
  }

  String? emailValidation(String? val) {
    if (val?.isEmpty ?? true) {
      return "Required*";
    } else if (!isValidEmail(val ?? "")) {
      return "Invalid email";
    }
    return null;
  }

  String? nameValidation(String? val) {
    if (val?.isEmpty ?? true) {
      return "Required*";
    }
    return null;
  }
}
