import 'package:flutter/material.dart';

class MeusVeiculosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Veículos'),
      ),
      body: Center(
        child: Text(
          'Aqui estarão os veículos cadastrados.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
