import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/api_config.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();

  String _selectedTypeEnergie = 'SOLAIRE';
  String _selectedStatusProjet = 'EN_ATTENTE';
  bool _isLoading = false;

  Future<void> _submitProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Token not found!')));
      setState(() => _isLoading = false);
      return;
    }

    final body = {
      "titre": _titreController.text,
      "description": _descriptionController.text,
      "region": _regionController.text,
      "montantRequis": double.tryParse(_montantController.text) ?? 0,
      "statusProjet": _selectedStatusProjet,
      "typeEnergie": _selectedTypeEnergie,
      "dateValidation": DateTime.now().toIso8601String(),
      "latitude": 0,
      "longitude": 0
    };

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.createProject),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project created successfully')));
        Navigator.pop(context); // close page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Failed: ${response.statusCode} - ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _regionController,
                decoration: const InputDecoration(labelText: 'Region'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _montantController,
                decoration: const InputDecoration(labelText: 'Amount Required'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedTypeEnergie,
                items: ['SOLAIRE', 'EOLIEN', 'BIOGAZ', 'HYDRO', 'AUTRE']
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedTypeEnergie = v);
                },
                decoration: const InputDecoration(labelText: 'Type Energie'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedStatusProjet,
                items: ['EN_ATTENTE', 'VALIDE', 'REJETE']
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedStatusProjet = v);
                },
                decoration: const InputDecoration(labelText: 'Status Projet'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitProject,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text('Create Project'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
