import 'package:flutter/material.dart';
import 'package:apk_softsolutions/models/categories.dart';
import 'package:apk_softsolutions/services/category_api_service.dart';
import 'package:apk_softsolutions/screens/categories/create_edit_category_screen.dart';

class ListCategoriesScreen extends StatefulWidget {
  const ListCategoriesScreen({super.key});

  @override
  _ListCategoriesScreenState createState() => _ListCategoriesScreenState();
}

class _ListCategoriesScreenState extends State<ListCategoriesScreen> {
  final CategoryApiService _apiService = CategoryApiService();
  List<Category> _categories = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final categories = await _apiService.getCategory();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar categorías: $e')),
      );
    }
  }

  void _deleteCategory(String id) async {
    try {
      await _apiService.deleteCategory(id);
      _loadCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categoría eliminada exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar categoría: $e')),
      );
    }
  }

  void _confirmDeleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text(
              '¿Está seguro que desea eliminar la categoría "${category.name}"?'),
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
                _deleteCategory(category.id);
              },
            ),
          ],
        );
      },
    );
  }

  List<Category> _filterCategories(String query) {
    return _categories.where((category) {
      final nameLower = category.name.toLowerCase();
      final descriptionLower = category.description.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower) ||
          descriptionLower.contains(queryLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _searchController.text.isNotEmpty
        ? _filterCategories(_searchController.text)
        : _categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar categorías',
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
                : filteredCategories.isEmpty
                    ? const Center(child: Text('No hay categorías'))
                    : ListView.builder(
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];
                          return ListTile(
                            title: Text(category.name),
                            subtitle: Text(category.description),
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
                                            CreateEditCategoryScreen(
                                          category: category,
                                        ),
                                      ),
                                    ).then((_) => _loadCategories());
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _confirmDeleteCategory(category),
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
              builder: (context) => const CreateEditCategoryScreen(),
            ),
          ).then((_) => _loadCategories());
        },
      ),
    );
  }
}
