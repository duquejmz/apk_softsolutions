import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apk_softsolutions/models/products.dart';

class ProductApiService {
  static const String baseUrl = "https://apirest-backend-frontend.onrender.com/api/products";

  // Listar todos los productos
  Future<List<Product>> getProduct() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> productsData = jsonDecode(response.body);
        return productsData.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception("Error en la API: ${response.body}");
      }
    } catch (e) {
      throw Exception('Error obteneindo los datos de productos: $e');
    }
  }

  // Crear producto
  Future<Product> postProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return Product.fromJson(jsonData['product']);
    } else {
      throw Exception("Error al crear producto");
    }
  }

  // Actualizar producto
  Future<Product> putProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Product.fromJson(jsonData['product']);
    } else {
      throw Exception("Error al actualizar producto");
    }
  }

  // Eliminar producto
  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar producto");
    }
  }

  // Buscar producto por ID
  Future<Product> getProductId(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Product.fromJson(jsonData['product']);
    } else {
      throw Exception("Error al buscar producto");
    }
  }
}
