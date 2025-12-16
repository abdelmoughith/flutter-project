import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/financement_event.dart';

class FinancementService {
  final String url;
  final String? token;

  FinancementService({required this.url, this.token});

  Future<List<FinancementEvent>> getFinancements() async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => FinancementEvent.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load financements');
    }
  }
}
