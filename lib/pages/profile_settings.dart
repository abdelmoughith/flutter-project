import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../utils/api_config.dart';
import '../entities/user.dart';
import 'login_page.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String username = 'Loading...';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiConfig.user),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(json.decode(response.body));
        setState(() {
          username = user.username;
          email = user.email;
        });
      } else {
        setState(() {
          username = 'Unknown';
          email = '';
        });
      }
    } catch (e) {
      setState(() {
        username = 'Unknown';
        email = '';
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person,
                        size: 50, color: AppColors.textOnPrimary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    username,
                    style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                        color: AppColors.textOnPrimary.withOpacity(0.9),
                        fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            _buildSettingTile(Icons.settings, "Account settings"),
            _buildSettingTile(Icons.lock, "Privacy"),
            _buildSettingTile(Icons.notifications, "Notifications"),
            _buildSettingTile(Icons.help_outline, "Help & Support"),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 16, color: AppColors.textSecondary),
        onTap: () {},
      ),
    );
  }
}
