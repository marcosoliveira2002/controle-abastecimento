import 'package:controle_abastecimento/data/firebase/veiculo_service.dart';
import 'package:flutter/material.dart';

class EditarVeiculoScreen extends StatefulWidget {
  final String id; 
  final String nome;
  final String modelo;
  final String ano;
  final String placa;

  EditarVeiculoScreen({
    required this.id,
    required this.nome,
    required this.modelo,
    required this.ano,
    required this.placa,
  });

  @override
  _EditarVeiculoScreenState createState() => _EditarVeiculoScreenState();
}

class _EditarVeiculoScreenState extends State<EditarVeiculoScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController anoController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final VeiculoService veiculoService = VeiculoService();

  @override
  void initState() {
    super.initState();

    nomeController.text = widget.nome;
    modeloController.text = widget.modelo;
    anoController.text = widget.ano;
    placaController.text = widget.placa;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Veículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome do Veículo',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: modeloController,
              decoration: InputDecoration(
                labelText: 'Modelo',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: anoController,
              decoration: InputDecoration(
                labelText: 'Ano',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: placaController,
              decoration: InputDecoration(
                labelText: 'Placa',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final nome = nomeController.text.trim();
                final modelo = modeloController.text.trim();
                final ano = anoController.text.trim();
                final placa = placaController.text.trim();

                if (nome.isEmpty || modelo.isEmpty || ano.isEmpty || placa.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, preencha todos os campos!')),
                  );
                  return;
                }

                try {
                  await veiculoService.editarVeiculo(widget.id, nome, modelo, ano, placa);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veículo atualizado com sucesso!')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao atualizar veículo: $e')),
                  );
                }
              },
              child: Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}