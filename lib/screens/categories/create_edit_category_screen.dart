import 'package:flutter/material.dart';
import 'package:apk_softsolutions/models/categories.dart';
import 'package:apk_softsolutions/services/category_api_service.dart';

class CreateEditCategoryScreen extends StatefulWidget {
  final Category? category;

  const CreateEditCategoryScreen({super.key, this.category});

  @override
  _CreateEditCategoryScreenState createState() =>
      _CreateEditCategoryScreenState();
}

class _CreateEditCategoryScreenState extends State<CreateEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final CategoryApiService _apiService = CategoryApiService();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.category?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final category = Category(
            id: widget.category?.id ?? '',
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim());

        if (widget.category == null) {
          // Crear nueva categoría
          await _apiService.postCategory(category);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Categoría creada exitosamente')),
          );
        } else {
          // Actualizar categoría existente
          await _apiService.putCategory(category);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Categoría actualizada exitosamente')),
          );
        }

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.category == null ? 'Crear Categoría' : 'Editar Categoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de Categoría',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveCategory,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        widget.category == null
                            ? 'Crear Categoría'
                            : 'Actualizar Categoría',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
