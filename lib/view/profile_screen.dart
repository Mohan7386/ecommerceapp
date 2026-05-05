import 'package:ecommerce_app/utils/app_text_styles.dart';
import 'package:ecommerce_app/view/edit_profile_screen.dart';
import 'package:ecommerce_app/view/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppTextStyle.withColor(Colors.black, AppTextStyle.h3),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            _buildProfileSection(context),
            SizedBox(height: 20),
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(23)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : AssetImage('assets/images/rx100.jpg') as ImageProvider,
          ),
          SizedBox(height: 10),
          Text(
            user?.displayName ?? "User",
            style: AppTextStyle.withColor(Colors.black, AppTextStyle.h3),
          ),
          Text(
            user?.email ?? "",
            style: AppTextStyle.withColor(Colors.black, AppTextStyle.bodyLarge),
          ),
          SizedBox(height: 16),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              side: BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditProfileScreen()),
              );
            },
            child: Text(
              "Edit Profile",
              style: AppTextStyle.withColor(
                Colors.blue,
                AppTextStyle.buttonMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.location_on_outlined,
        'title': 'Shipping Address',
        'type': 'address',
      },
      {'icon': Icons.help_outline, 'title': 'Help Center', 'type': 'help'},
      {'icon': Icons.logout_outlined, 'title': 'Logout', 'type': 'logout'},
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: menuItems.map((item) {
          return Container(
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(item['icon'] as IconData, color: Colors.blue),
              title: Text(
                item['title'] as String,
                style: AppTextStyle.bodyLarge,
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                if (item['type'] == 'logout') {
                  _showLogoutDialog(context);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // dialog close
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // dialog close
                await context.read<AuthProvider>().logout();
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
