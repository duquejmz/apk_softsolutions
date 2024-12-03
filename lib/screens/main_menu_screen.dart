import 'package:flutter/material.dart';
import 'package:apk_softsolutions/screens/login_screen.dart';
import 'package:apk_softsolutions/screens/products/list_products_screen.dart';
import 'package:apk_softsolutions/screens/categories/list_category_screen.dart';
import 'package:apk_softsolutions/screens/developer_info_screen.dart';
import 'package:apk_softsolutions/services/auth_service.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  void _logout(BuildContext context) async {
    await AuthService().logout();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SoftSolutions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 88,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 225, 189, 240),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Menú Principal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDrawerItem(context, 'Productos', Icons.shopping_bag,
                const ListProductsScreen()),
            _buildDrawerItem(context, 'Categorías', Icons.category,
                const ListCategoriesScreen()),
            _buildDrawerItem(context, 'Desarrollador', Icons.person,
                const DeveloperInfoScreen()),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de la aplicación
            Image.asset(
              'assets/logo.png',
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, String text, IconData icon, Widget screen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        // Cerrar el drawer
        Navigator.of(context).pop();
        // Navegar a la pantalla seleccionada
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => screen));
      },
    );
  }
}
