import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:home_automation/app/controllers/dashboard_controller.dart';
import 'package:home_automation/app/views/shared/text_widget.dart';
import 'package:home_automation/app/views/shared/wave_loading.dart';
import 'package:home_automation/common/colors.dart';
import 'package:home_automation/utils/text_field_decoration.dart';

class AddRoom extends StatelessWidget {
  const AddRoom({super.key});
  static final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25) +
              const EdgeInsets.only(top: 60),
          child: Form(
            key: dashboardController.addRoomGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                    const Text(
                      "Add Room",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                    child: Image.asset(
                  "assets/png/logo.png",
                  height: 100,
                )),
                const SizedBox(height: 40),
                Obx(
                  () => GestureDetector(
                    onTap: () => dashboardController.imagePick(),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white,
                          )),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          dashboardController.imageFile?.value != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.file(
                                    dashboardController.imageFile!.value ??
                                        File(''),
                                    fit: BoxFit.fitWidth,
                                    width: double.infinity,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          SvgPicture.asset("assets/svg/file_picker.svg")
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const CustomTextWidget(
                  text: "Room Name",
                  color: Colors.white,
                  fontSize: 16,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dashboardController.title,
                  validator: dashboardController.nameValidation,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.done,
                  decoration: inputDecoration(hintText: "Your Room Name"),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Obx(
                    () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 48),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () => dashboardController.onRoomCreate(),
                        child: dashboardController.isRoomLoading.value
                            ? const WaveLoadingWidget()
                            : const CustomTextWidget(
                                text: "Add Room",
                                color: AppColors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
