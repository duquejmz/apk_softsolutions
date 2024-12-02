import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apk_softsolutions/models/categories.dart';

class CategoryApiService {
  static const String baseUrl =
      "https://apirest-backend-frontend.onrender.com/api/category";

  // Listar todas las categorías
  Future<List<Category>> getCategory() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      if (decodedData is List) {
        // Si es una lista
        return decodedData.map((item) => Category.fromJson(item)).toList();
      } else if (decodedData is Map<String, dynamic> &&
          decodedData.containsKey('categories')) {
        // Si es un mapa con 'categories'
        final categoriesData = decodedData['categories'] as List;
        return categoriesData.map((item) => Category.fromJson(item)).toList();
      } else {
        throw Exception("Formato de respuesta inesperado");
      }
    } else {
      throw Exception("Error al cargar categorías");
    }
  }

  // Crear categoría
  Future<void> postCategory(Category category) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          category.toJson()), // Usa el método toJson de la clase Category
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear categoría');
    }
  }

  // Actualizar categoría
  Future<void> putCategory(Category category) async {
    if (category.id.isEmpty) {
      throw Exception('El Id de la categoria no puede estar vacio');
    }
    final response = await http.put(
      Uri.parse('$baseUrl/${category.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(category.toJson()), // Serializa el objeto correctamente
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar categoría: ${response.body}');
    }
  }

  // Eliminar categoría
  Future<void> deleteCategory(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar categoría");
    }
  }

  // Buscar categoría por ID
  Future<Category> getCategoryId(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Category.fromJson(jsonData['category']);
    } else {
      throw Exception("Error al buscar categoría");
    }
  }
}
