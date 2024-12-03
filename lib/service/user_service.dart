import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = 'http://10.0.2.2:3000';
  //static const String baseUrl = 'http://localhost:3000';

  Future<int> getNewId() async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      if (users.isEmpty) return 1;
      final List<int> ids = users.map((user) => user['id'] as int).toList();
      return ids.reduce((a, b) => a > b ? a : b) + 1;
    } else {
      throw Exception(
          'Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to post data. Status code: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to update data. Status code: ${response.statusCode}');
    }
  }

  Future<void> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Failed to delete data. Status code: ${response.statusCode}');
    }
  }
}
