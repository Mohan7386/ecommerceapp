import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/home_screen.dart';
import 'package:ecommerce_app/view/widgets/custom_textField.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(18),
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
                  style: AppTextStyle.withColor(Colors.black, AppTextStyle.h1),
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
                  label: "Full Name",
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: 22),
                CustomTextField(
                  label: "Email",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  label: "Mobile Number",
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 21),
                CustomTextField(
                  label: "Confirm Password",
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),
                SizedBox(height: 20),

                // Sign UP Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
