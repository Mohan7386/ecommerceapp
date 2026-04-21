import 'package:ecommerce_app/controller/auth_controller.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/signUp_Screen.dart';
import 'package:ecommerce_app/view/widgets/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Text
                    Text(
                      "Welcome Back",
                      style: AppTextStyle.withColor(
                        Colors.black,
                        AppTextStyle.h1,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Sign in to continue your shopping",
                      style: AppTextStyle.withColor(
                        Colors.grey.shade700,
                        AppTextStyle.bodyLarge,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Email TextField
                    CustomTextField(
                      label: "Email",
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 18),

                    // Password TextField
                    CustomTextField(
                      label: "Password",
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                    ),
                    SizedBox(height: 20),

                    // Forget PassWord
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forget Password?",
                          style: AppTextStyle.withColor(
                            Colors.blue,
                            AppTextStyle.buttonMedium,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          context.read<AuthProvider>().login();
                        },
                        child: Text(
                          "Sign In",
                          style: AppTextStyle.withColor(
                            Colors.white,
                            AppTextStyle.buttonMedium,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Sign Up Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyle.withColor(
                            Colors.grey.shade700,
                            AppTextStyle.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: AppTextStyle.withColor(
                              Colors.blue,
                              AppTextStyle.buttonLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
