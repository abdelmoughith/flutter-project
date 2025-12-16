import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/green_project.dart';

class ProjectService {
  final String url;
  final String? token;

  ProjectService({required this.url, this.token});

  Future<List<GreenProject>> getAllProjects() async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => GreenProject.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }
}
