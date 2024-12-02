import 'package:flutter/material.dart';
import 'package:apk_softsolutions/models/products.dart';
import 'package:apk_softsolutions/services/products/api_service.dart';
import 'package:apk_softsolutions/screens/products/create_edit_product_screen.dart';

class ListProductsScreen extends StatefulWidget {
  const ListProductsScreen({super.key});

  @override
  _ListProductsScreenState createState() => _ListProductsScreenState();
}

class _ListProductsScreenState extends State<ListProductsScreen> {
  final ProductApiService _apiService = ProductApiService();
  List<Product> _products = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final products = await _apiService.getProduct();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  void _deleteProduct(String id) async {
    try {
      await _apiService.deleteProduct(id);
      _loadProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto eliminado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar producto: $e')),
      );
    }
  }

  void _confirmDeleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text(
              '¿Está seguro que desea eliminar el producto "${product.name}"?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(product.id);
              },
            ),
          ],
        );
      },
    );
  }

  List<Product> _filterProducts(String query) {
    return _products.where((product) {
      final nameLower = product.name.toLowerCase();
      final descriptionLower = product.description.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower) ||
          descriptionLower.contains(queryLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _searchController.text.isNotEmpty
        ? _filterProducts(_searchController.text)
        : _products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar productos',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                    ? const Center(child: Text('No hay productos'))
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ListTile(
                            title: Text(product.name),
                            subtitle: Text(
                              '${product.description}\nPrecio: \$${product.price} - Stock: ${product.stock}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateEditProductScreen(
                                          product: product,
                                        ),
                                      ),
                                    ).then((_) => _loadProducts());
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _confirmDeleteProduct(product),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateEditProductScreen(),
            ),
          ).then((_) => _loadProducts());
        },
      ),
    );
  }
}
