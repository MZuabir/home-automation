import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:home_automation/app/data/firebase_service.dart';
import 'package:home_automation/app/data/models/user_model.dart';
import 'package:home_automation/common/shared_functions.dart';
import 'package:home_automation/screens/home_screen.dart';
import 'package:home_automation/utils/getx_snackbar.dart';
import 'package:home_automation/utils/logger.dart';
import 'package:image_picker/image_picker.dart';

class DashboardController extends GetxController {
  Rx<UserModel?>? userData = Rx<UserModel?>(null);
  TextEditingController title = TextEditingController();
  TextEditingController appliance = TextEditingController();
  GlobalKey<FormState> addRoomGlobalKey = GlobalKey<FormState>();
  GlobalKey<FormState> addApplianceGlobalKey = GlobalKey<FormState>();

  RxBool isRoomLoading = false.obs;
  RxBool isApplianceLoading = false.obs;
  Rx<File?>? imageFile = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    Logger.info("Dashboard on init called");
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.email ?? "")
        .snapshots()
        .listen((event) {
      userData?.value = UserModel.fromJson(event.data() ?? {});
    });
  }

  Future<void> onRoomCreate() async {
    try {
      if (addRoomGlobalKey.currentState?.validate() ?? false) {
        if (imageFile?.value != null) {
          isRoomLoading.value = true;

          String photoUrl = await FireBaseServices()
              .uploadPhoto(imageFile?.value ?? File(''));
          FirebaseFirestore.instance
              .collection("rooms")
              .doc(title.text.trim().replaceAll(' ', ''))
              .set({
            "email": FirebaseAuth.instance.currentUser?.email,
            "image": photoUrl,
            "title": title.text.trim()
          });
          Snack.showSuccessSnackBar("Room created successfully");
          isRoomLoading.value = false;
          Get.offAll(() => const HomePage());
          clearAddRoomCont();
        } else {
          Snack.showInfoSnackBar("Pick Image first.");
        }
      }
    } catch (e) {
      isRoomLoading.value = false;
      Logger.error(e);
      Snack.showErrorSnackBar(handleException(e));
    }
  }

  Future<void> onApplianceCreate(String docPath) async {
    try {
      if (addApplianceGlobalKey.currentState?.validate() ?? false) {
        isApplianceLoading.value = true;

        FirebaseFirestore.instance
            .collection("rooms")
            .doc(docPath)
            .collection('sensors')
            .doc(appliance.text.trim().replaceAll(" ", ""))
            .set({
          "title": appliance.text.trim(),
          'state': false,
        });
        Snack.showSuccessSnackBar("Room created successfully");
        isApplianceLoading.value = false;
      }
    } catch (e) {
      isApplianceLoading.value = false;
      Logger.error(e);
      Snack.showErrorSnackBar(handleException(e));
    }
  }

  clearAddRoomCont() {
    addRoomGlobalKey = GlobalKey<FormState>();
    addRoomGlobalKey.currentState?.reset();
    title.clear();
    imageFile?.value = null;
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

  String? nameValidation(String? val) {
    if (val?.isEmpty ?? true) {
      return "Required*";
    }
    return null;
  }
}
