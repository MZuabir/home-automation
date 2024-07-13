import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_automation/app/controllers/auth_controller.dart';
import 'package:home_automation/app/views/auth/login.dart';
import 'package:home_automation/app/views/shared/text_widget.dart';
import 'package:home_automation/app/views/shared/wave_loading.dart';
import 'package:home_automation/common/colors.dart';
import 'package:home_automation/utils/text_field_decoration.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  static final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: authController.signupGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kToolbarHeight + 30),
                Center(
                    child: Image.asset(
                  "assets/png/logo.png",
                  height: 180,
                  width: 350,
                  fit: BoxFit.cover,
                )),
                const CustomTextWidget(
                  text: "Name",
                  color: Colors.white,
                  fontSize: 16,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: authController.name,
                  validator: authController.nameValidation,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(color: Colors.white),
                  decoration: inputDecoration(
                    hintText: "Your Name",
                  ),
                ),
                const SizedBox(height: 20),
                const CustomTextWidget(
                  text: "Email",
                  color: Colors.white,
                  fontSize: 16,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: authController.email,
                  validator: authController.emailValidation,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.white),
                  decoration: inputDecoration(hintText: "Your Email"),
                ),
                const SizedBox(height: 20),
                const CustomTextWidget(
                  text: "Password",
                  color: Colors.white,
                  fontSize: 16,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: authController.password,
                  validator: authController.passwordValidation,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(color: Colors.white),
                  decoration: inputDecoration(hintText: "Your password"),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => GestureDetector(
                    onTap: () => authController.imagePick(),
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
                          authController.imageFile?.value != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.file(
                                    authController.imageFile!.value ?? File(''),
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
                Center(
                  child: Obx(
                    () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 48),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () => authController.onSignup(),
                        child: authController.isLoadingSignup.value
                            ? const WaveLoadingWidget()
                            : const CustomTextWidget(
                                text: "Signup",
                                color: AppColors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomTextWidget(
                      text: "Already have an account?",
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    TextButton(
                        onPressed: () => Get.off(() => const LoginScreen()),
                        child: const CustomTextWidget(
                          text: "Login",
                          color: Colors.white,
                          fontSize: 16,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
