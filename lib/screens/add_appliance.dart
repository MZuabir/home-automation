import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_automation/app/controllers/dashboard_controller.dart';
import 'package:home_automation/app/views/shared/text_widget.dart';
import 'package:home_automation/app/views/shared/wave_loading.dart';
import 'package:home_automation/common/colors.dart';
import 'package:home_automation/utils/text_field_decoration.dart';

class AddAppliancePage extends StatelessWidget {
  const AddAppliancePage({super.key, required this.docPath});
  final String docPath;
  static final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25) +
            EdgeInsets.only(top: 60),
        child: Form(
          key: dashboardController.addApplianceGlobalKey,
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
                    "Add Appliance",
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
                // fit: BoxFit.cover,
              )),
              const SizedBox(height: 40),
              const SizedBox(height: 20),
              const CustomTextWidget(
                text: "Appliance Name",
                color: Colors.white,
                fontSize: 16,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: dashboardController.appliance,
                validator: dashboardController.nameValidation,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: const TextStyle(color: Colors.white),
                textInputAction: TextInputAction.done,
                decoration: inputDecoration(hintText: "Your Appliance Name"),
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
                      onPressed: () =>
                          dashboardController.onApplianceCreate(docPath),
                      child: dashboardController.isApplianceLoading.value
                          ? const WaveLoadingWidget()
                          : const CustomTextWidget(
                              text: "Add Appliance",
                              color: AppColors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                ),
              ),
              // ElevatedButton(
              //     onPressed: () {
              // FirebaseFirestore.instance
              //     .collection('demo2@gmail.com')
              //     .doc(docPath)
              //     .collection('sensors')
              //     .doc(title.text.trim())
              //     .set({
              //   "title": title.text.trim(),
              //   'state': false,
              // }).then((value) => Navigator.pop(context));
              // },
              // child: const Text("Add Appliance"))
            ],
          ),
        ),
      ),
    );
  }
}
