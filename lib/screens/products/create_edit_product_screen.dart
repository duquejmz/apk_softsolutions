import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apk_softsolutions/models/products.dart';
import 'package:apk_softsolutions/models/categories.dart';
import 'package:apk_softsolutions/services/products/api_service.dart';
import 'package:apk_softsolutions/services/category_api_service.dart';

class CreateEditProductScreen extends StatefulWidget {
  final Product? product;

  const CreateEditProductScreen({super.key, this.product});

  @override
  _CreateEditProductScreenState createState() =>
      _CreateEditProductScreenState();
}

class _CreateEditProductScreenState extends State<CreateEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductApiService _productApiService = ProductApiService();
  final CategoryApiService _categoryApiService = CategoryApiService();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  String? _selectedCategory;
  List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockController =
        TextEditingController(text: widget.product?.stock.toString() ?? '');
    // _selectedCategory = widget.product?.category;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _categoryApiService.getCategory();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar categorías: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final product = Product(
            id: widget.product?.id ?? '',
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            price: double.parse(_priceController.text.trim()),
            stock: int.parse(_stockController.text.trim()),
            category: _selectedCategory!);

        if (widget.product == null) {
          // Crear nuevo producto
          await _productApiService.postProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto creado exitosamente')),
          );
        } else {
          // Actualizar producto existente
          await _productApiService.putProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto actualizado exitosamente')),
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
        title:
            Text(widget.product == null ? 'Crear Producto' : 'Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Producto',
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese un precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingrese un precio válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese el stock';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: _selectedCategory,
                hint: const Text('Seleccione una categoría'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione una categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveProduct,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        widget.product == null
                            ? 'Crear Producto'
                            : 'Actualizar Producto',
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
