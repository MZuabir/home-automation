import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_automation/app/controllers/auth_controller.dart';
import 'package:home_automation/app/views/auth/sign_up.dart';
import 'package:home_automation/app/views/shared/text_widget.dart';
import 'package:home_automation/app/views/shared/wave_loading.dart';
import 'package:home_automation/common/colors.dart';
import 'package:home_automation/utils/text_field_decoration.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static final AuthController authCont = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: authCont.loginGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kToolbarHeight + 30),
                Center(
                    child: Image.asset(
                  "assets/png/logo.png",
                  height: 100,
                  // fit: BoxFit.cover,
                )),
                const CustomTextWidget(
                  text: "Email",
                  color: Colors.white,
                  fontSize: 16,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: authCont.email,
                  validator: authCont.emailValidation,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  controller: authCont.password,
                  validator: authCont.passwordValidation,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(color: Colors.white),
                  decoration: inputDecoration(hintText: "Your password"),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Obx(
                    () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 48),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () => authCont.onLogin(),
                        child: authCont.isLoadingLogin.value
                            ? const WaveLoadingWidget()
                            : const CustomTextWidget(
                                text: "Login",
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
                      text: "Don't have an account?",
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    TextButton(
                        onPressed: () => Get.off(() => const SignUpScreen()),
                        child: const CustomTextWidget(
                          text: "Signup",
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
