import 'package:flutter/material.dart';

class HistoricoAbastecimentosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Abastecimentos'),
      ),
      body: Center(
        child: Text(
          'Aqui estará o histórico de abastecimentos.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
