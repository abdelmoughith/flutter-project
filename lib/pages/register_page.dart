import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/app_colors.dart';
import '../utils/api_config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _birthday;
  bool _isLoading = false;
  final double _cardPadding = 24.0;

  Future<void> _selectBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _birthday = picked;
      });
    }
  }

  Future<void> register() async {
    if (_birthday == null) {
      _showSnackBar("Please select your birthday");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
          "firstName": _firstNameController.text.trim(),
          "lastName": _lastNameController.text.trim(),
          "phoneNumber": _phoneController.text.trim(),
          "address": _addressController.text.trim(),
          "birthday": _birthday!.toIso8601String().split('T').first,
        }),
      );

      // ✅ SUCCESS: backend returns plain string
      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar(response.body);
        Navigator.pop(context); // back to login
        return;
      }

      // ❌ ERROR: backend returns JSON
      final decoded = jsonDecode(response.body);
      _showSnackBar(decoded.values.first.toString());

    } catch (e) {
      _showSnackBar("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(_cardPadding),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            color: AppColors.surface,
            child: Padding(
              padding: EdgeInsets.all(_cardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add_alt_1,
                      size: 72, color: AppColors.primary),
                  const SizedBox(height: 16),

                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Register to continue",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  _input(_emailController, "Email", Icons.email),
                  _input(_passwordController, "Password", Icons.lock,
                      obscure: true),
                  _input(_firstNameController, "First Name", Icons.badge),
                  _input(_lastNameController, "Last Name", Icons.badge),
                  _input(_phoneController, "Phone Number", Icons.phone),
                  _input(_addressController, "Address", Icons.location_on),

                  const SizedBox(height: 12),

                  // 🎂 Birthday selector
                  InkWell(
                    onTap: _selectBirthday,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Birthday",
                        prefixIcon: Icon(Icons.cake),
                      ),
                      child: Text(
                        _birthday == null
                            ? "Select your birthday"
                            : _birthday!
                            .toIso8601String()
                            .split('T')
                            .first,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : register,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : const Text("Register"),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label, IconData icon,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
