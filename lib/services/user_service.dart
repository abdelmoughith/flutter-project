import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';

Future<String> fetchUsername() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  if (token == null) throw Exception('No token found');

  final response = await http.get(
    Uri.parse(ApiConfig.username), // should be '/api/user'
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // API returns a plain string like "ahmed"
    return response.body.replaceAll('"', ''); // remove quotes
  } else {
    throw Exception('Failed to fetch username');
  }
}
