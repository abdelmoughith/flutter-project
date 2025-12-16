import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entities/green_project.dart';
import '../entities/financement_event.dart';
import '../services/financement_service.dart';
import '../utils/api_config.dart';
import '../widgets/financement_list.dart';
import 'finance_project.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_colors.dart';

class ProjectDetailsPage extends StatefulWidget {
  final GreenProject project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  bool _isLoading = true;
  GreenProject? _fullProject;

  @override
  void initState() {
    super.initState();
    _fetchProjectDetails();
  }

  Future<void> _fetchProjectDetails() async {
    setState(() => _isLoading = true);

    final url = '${ApiConfig.allProjects}/${widget.project.id}';
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _fullProject = GreenProject.fromJson(data);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load project details');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fullProject == null
          ? const Center(child: Text('Project not found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project info
            Text(
              _fullProject!.titre,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _fullProject!.description,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Region: ${_fullProject!.region}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount Required: ${_fullProject!.montantRequis}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Collected: ${_fullProject!.montantCollecte}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Type Energie: ${_fullProject!.typeEnergie}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // Button to finance
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FinanceProjectPage(projectId: _fullProject!.id),
                    ),
                  );
                },
                child: const Text("Finance Project"),
              ),
            ),
            const SizedBox(height: 16),

            // Financements list
            Text(
              'Financements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 400, // fixed height for list
              child: FinancementList(
                url:
                '${ApiConfig.projectFinancements}/${widget.project.id}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
