import 'package:ecommerce_app/controller/auth_provider.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/utils/validators/validation.dart';
import 'package:ecommerce_app/view/sign_up_screen.dart';
import 'package:ecommerce_app/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'forget_password_screen.dart';
import 'main_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800;
          return Container(
            color: isDesktop ? Colors.grey[200] : Colors.white,
            child: Center(
              child: Container(
                width: isDesktop ? 400 : double.infinity,
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Form(
                          key: _formKey,
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
                                controller: emailController,
                                label: "Email",
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: Validator.validateEmail,
                              ),
                              SizedBox(height: 19),

                              // Password TextField
                              CustomTextField(
                                controller: passwordController,
                                label: "Password",
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                validator: Validator.validatePassword,
                              ),
                              SizedBox(height: 20),

                              // Forget PassWord
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
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
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final error = await context
                                          .read<AuthProvider>()
                                          .login(
                                           email: emailController.text,
                                           password:  passwordController.text,
                                          );

                                      if (!mounted) return;

                                      if (error != null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(error)),
                                        );
                                      }
                                    }
                                  },
                                  child: context.watch<AuthProvider>().isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          "Sign In",
                                          style: AppTextStyle.withColor(
                                            Colors.white,
                                            AppTextStyle.buttonMedium,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "or continue with",
                                style: AppTextStyle.bodyLarge,
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
                                    else {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MainScreen(),
                                        ),
                                            (route) => false,
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
              ),
            ),
          );
        },
      ),
    );
  }
}
