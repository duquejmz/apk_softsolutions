import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "https://apirest-backend-frontend.onrender.com/login";

  Future<bool> Login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password
        }),
      );

      if (response.statusCode == 200) {
        // Guardar token o información de sesión si es necesario
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Almacenar información de sesión en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error de autenticación: $e');
      return false;
    }
  }

  Future<void> logout() async {
    // Limpiar información de sesión
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userEmail');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}