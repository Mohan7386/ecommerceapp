import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controller/auth_controller.dart';
import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    nameController.text = user?.displayName ?? '';
    // Phone Firestore load
    _loadPhone();
  }

  Future<void> _loadPhone() async {
    final uid = context.read<AuthProvider>().user?.uid;
    if (uid == null) return;
    // Firestore
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      phoneController.text = doc['phone'] ?? '';
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile",
            style: AppTextStyle.withColor(Colors.black, AppTextStyle.h3)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Photo
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: _pickedImage != null
                        ? FileImage(_pickedImage!)
                        : (user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : AssetImage('assets/images/rx100.jpg'))
                    as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.lightBlue,
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Profile Form
            Form(
              key: _profileFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Personal Info", style: AppTextStyle.h3),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Name required" : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Phone required" : null,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                        if (_profileFormKey.currentState!.validate()) {
                          final error = await auth.updateProfile(
                            name: nameController.text.trim(),
                            phone: phoneController.text.trim(),
                            imagePath: _pickedImage?.path,
                          );
                          if (!mounted) return;
                          if (error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Profile updated successfully!")));
                          }
                        }
                      },
                      child: auth.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Update Profile",
                          style: AppTextStyle.withColor(
                              Colors.white, AppTextStyle.buttonMedium)),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),
            Divider(),
            SizedBox(height: 16),

            // Password Change Form
            Form(
              key: _passwordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Change Password", style: AppTextStyle.h3),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Current Password",
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Required";
                      if (v.length < 6) return "Min 6 characters";
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: auth.isPasswordLoading
                          ? null
                          : () async {
                        if (_passwordFormKey.currentState!.validate()) {
                          final error = await auth.changePassword(
                            currentPassword:
                            currentPasswordController.text.trim(),
                            newPassword:
                            newPasswordController.text.trim(),
                          );
                          if (!mounted) return;
                          if (error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Password changed successfully!")));
                            currentPasswordController.clear();
                            newPasswordController.clear();
                          }
                        }
                      },
                      child: auth.isPasswordLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Change Password",
                          style: AppTextStyle.withColor(
                              Colors.white, AppTextStyle.buttonMedium)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }
}
