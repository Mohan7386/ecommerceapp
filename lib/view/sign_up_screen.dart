import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/utils/validators/validation.dart';
import 'package:ecommerce_app/view/home_screen.dart';
import 'package:ecommerce_app/view/main_screen.dart';
import 'package:ecommerce_app/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String name = "", phone = "", email = "", password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          bool isDesktop = constraints.maxWidth > 800;
          return Container(
            color: isDesktop ? Colors.grey[200] : Colors.white,
            child: Center(
              child: Container(
                width: isDesktop ? 400 : double.infinity,
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // back Button
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios),
                          ),
                          SizedBox(height: 24),
                          // Text
                          Text(
                            "Create Your Account",
                            style: AppTextStyle.withColor(
                              Colors.black,
                              AppTextStyle.h1,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Create Your Account to Start Shopping",
                            style: AppTextStyle.withColor(
                              Colors.grey.shade700,
                              AppTextStyle.bodyMedium,
                            ),
                          ),
                          SizedBox(height: 30),

                          CustomTextField(
                            controller: nameController,
                            label: "Full Name",
                            prefixIcon: Icons.person,
                            keyboardType: TextInputType.name,
                            validator: Validator.validateName,
                          ),
                          SizedBox(height: 22),
                          CustomTextField(
                            controller: emailController,
                            label: "Email",
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validator.validateEmail,
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: phoneController,
                            label: "Mobile Number",
                            prefixIcon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            validator: Validator.validatePhone,
                          ),
                          SizedBox(height: 21),
                          CustomTextField(
                            controller: passwordController,
                            label: " Password",
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            validator: Validator.validatePassword,
                          ),
                          SizedBox(height: 20),

                          // Sign UP Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  print(" Button Pressed!");
                                  print(" Email: '${emailController.text}'");
                                  print(" Password: '${passwordController.text}'");

                                  if (_formKey.currentState!.validate()) {
                                    print(" Form Valid!");
                                    final error = await context
                                        .read<AuthProvider>()
                                        .signUp(
                                      nameController.text,
                                      phoneController.text,
                                      emailController.text,
                                      passwordController.text,
                                    );

                                    if (!mounted) return;

                                    if (error != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(error)),
                                      );
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    print("Form Invalid!");
                                  }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                "Sign Up",
                                style: AppTextStyle.withColor(
                                  Colors.white,
                                  AppTextStyle.buttonMedium,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 26),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: AppTextStyle.withColor(
                                  Colors.grey.shade800,
                                  AppTextStyle.bodyMedium,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Sign In",
                                  style: AppTextStyle.withColor(
                                    Colors.blue,
                                    AppTextStyle.buttonLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "or continue with",
                              style: AppTextStyle.bodyLarge,
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                final error = await context
                                    .read<AuthProvider>()
                                    .signInWithGoogle();

                                if (!mounted) return;

                                if (error != null) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                }
                              },
                              child: Text(
                                "Continue With Google",
                                style: AppTextStyle.h3,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
