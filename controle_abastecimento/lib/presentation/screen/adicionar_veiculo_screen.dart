import 'package:controle_abastecimento/data/firebase/veiculo_service.dart';
import 'package:flutter/material.dart';


class AdicionarVeiculoScreen extends StatefulWidget {
  @override
  _AdicionarVeiculoScreenState createState() => _AdicionarVeiculoScreenState();
}

class _AdicionarVeiculoScreenState extends State<AdicionarVeiculoScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController anoController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final VeiculoService veiculoService = VeiculoService(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Veículo'),
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
                  // Chamando o serviço de cadastro de veículo
                  await veiculoService.cadastrarVeiculo(nome, modelo, ano, placa);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veículo cadastrado com sucesso!')),
                  );

                  // Após cadastro, redirecionar para a tela de Meus Veículos
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao cadastrar veículo: $e')),
                  );
                }
              },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
