import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Text(
          'Aqui estarão os dados do perfil.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
