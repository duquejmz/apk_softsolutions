import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apk_softsolutions/models/users.dart';

class UserService {
  static const String baseUrl = "https://apirest-backend-frontend.onrender.com/api/user";
  static const String baseURL = "https://apirest-backend-frontend.onrender.com/login";

  // Register a new user
  Future<Map<String, dynamic>> registerUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'User created successfully',
          'data': jsonDecode(response.body)
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['msg'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error connecting to server: $e'
      };
    }
  }

  // Login user
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseURL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'token': jsonDecode(response.body)['msg'],
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['msg'] ?? 'Login failed'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error connecting to server: $e'
      };
    }
  }
}