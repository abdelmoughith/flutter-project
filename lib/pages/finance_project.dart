import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/api_config.dart';
import '../theme/app_colors.dart';

class FinanceProjectPage extends StatefulWidget {
  final int projectId;

  const FinanceProjectPage({super.key, required this.projectId});

  @override
  State<FinanceProjectPage> createState() => _FinanceProjectPageState();
}

class _FinanceProjectPageState extends State<FinanceProjectPage> {
  final TextEditingController _amountController = TextEditingController();
  bool _loading = false;

  Future<void> _financeProject() async {
    final montantText = _amountController.text.trim();
    if (montantText.isEmpty) return;

    final montant = double.tryParse(montantText);
    if (montant == null || montant < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le montant doit être au moins 100")),
      );
      return;
    }

    setState(() => _loading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vous devez être connecté")),
      );
      setState(() => _loading = false);
      return;
    }

    final url = '${ApiConfig.projectFinancements}/${widget.projectId}';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'montant': montant}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Financement réussi !")),
        );
        Navigator.pop(context); // close page on success
      } else {
        final error = response.body;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: $error")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance Project"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Montant à financer",
                prefixIcon: Icon(Icons.euro),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _financeProject,
                child: _loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text("Financer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
