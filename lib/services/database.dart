import 'dart:convert';
import 'package:pizzeria/model/user.dart';
import 'package:http/http.dart' as http;

class DatabaseMethods {
  String baseUrl = "https://devya.shop";
  Future addTodoWork(Map<String, dynamic> req, String id, String token) async {
    String loginUrl = "$baseUrl/api/todos";
    return await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      },
      body: jsonEncode(req),
    );
  }

  Future<List<Map<String, dynamic>>> getAllTodos(String userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/todos/user/$userId"),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to fetch todos");
    }
  }

  Future updateTick(String id, Map<String, dynamic> req, String token) async {
    String loginUrl = "$baseUrl/api/todos/$id";
    return await http.put(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(req),
    );
  }

  Future loginUser(User user) async {
    String loginUrl = "$baseUrl/auth/login";

    Map<String, dynamic> body = {
      'email': user.email,
      'password': user.password,
      // Add any other fields required by your backend
    };

    return await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future registerUser(User user) async {
    String loginUrl = "$baseUrl/users";

    Map<String, dynamic> body = {
      'email': user.email,
      'password': user.password,
      "name": user.name,
      "about": "this is me",
      "gender": "male",
      "confirmBankAccountNumber": "",
      "bankAccountNumber": "",
      "ifscCode": "",
      "bankName": "",
      "accountType": "User",
      // Add any other fields required by your backend
    };

    return await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }
}
