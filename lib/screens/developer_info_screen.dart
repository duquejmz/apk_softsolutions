import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperInfoScreen extends StatelessWidget {
  const DeveloperInfoScreen({super.key});

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Desarrollador'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto del desarrollador (opcional)
              const CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(
                    'assets/developer.jpg'), // Asegúrate de tener esta imagen
              ),
              const SizedBox(height: 20),

              const Text(
                'Desarrollador',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Nombre Completo: Tu Nombre Completo',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),

              const Text(
                'Celular: +57 123 4567890',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),

              const Text(
                'Correo: tucorreo@ejemplo.com',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),

              // Botones de redes sociales o contacto (opcional)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.email, size: 40),
                    onPressed: () => _launchURL('mailto:tucorreo@ejemplo.com'),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.phone, size: 40),
                    onPressed: () => _launchURL('tel:+571234567890'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
