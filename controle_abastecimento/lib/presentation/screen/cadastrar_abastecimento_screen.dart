import 'package:flutter/material.dart';
import 'package:controle_abastecimento/data/firebase/abastecimento_service.dart';

class CadastrarAbastecimentoScreen extends StatelessWidget {
  final String veiculoId;
  final String veiculoNome;

  CadastrarAbastecimentoScreen({
    required this.veiculoId,
    required this.veiculoNome,
  });

  final TextEditingController litrosController = TextEditingController();
  final TextEditingController quilometragemController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  final AbastecimentoService abastecimentoService = AbastecimentoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Abastecimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Veículo: $veiculoNome',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: litrosController,
              decoration: InputDecoration(labelText: 'Quantidade de Litros'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: quilometragemController,
              decoration: InputDecoration(labelText: 'Quilometragem Atual'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: dataController,
              decoration: InputDecoration(labelText: 'Data (dd/mm/aaaa)'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final litros = litrosController.text.trim();
                final quilometragem = quilometragemController.text.trim();
                final dataText = dataController.text.trim();

                if (litros.isEmpty || quilometragem.isEmpty || dataText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha todos os campos!')),
                  );
                  return;
                }

                try {
                  final data = DateTime.parse(
                      "${dataText.split('/')[2]}-${dataText.split('/')[1]}-${dataText.split('/')[0]}");

                  await abastecimentoService.cadastrarAbastecimento(
                    veiculoId,
                    double.parse(litros),
                    int.parse(quilometragem),
                    data,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Abastecimento cadastrado com sucesso!')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao cadastrar: $e')),
                  );
                }
              },
              child: Text('Cadastrar Abastecimento'),
            ),
          ],
        ),
      ),
    );
  }
}
