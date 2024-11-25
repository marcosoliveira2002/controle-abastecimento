import 'package:controle_abastecimento/data/firebase/abastecimento_service.dart';
import 'package:controle_abastecimento/data/firebase/veiculo_service.dart';
import 'package:flutter/material.dart';

class HistoricoAbastecimentosScreen extends StatefulWidget {
  @override
  _HistoricoAbastecimentosScreenState createState() =>
      _HistoricoAbastecimentosScreenState();
}

class _HistoricoAbastecimentosScreenState
    extends State<HistoricoAbastecimentosScreen> {
  final AbastecimentoService abastecimentoService = AbastecimentoService();
  final VeiculoService veiculoService = VeiculoService();
  late Future<List<Map<String, dynamic>>> historicoFuture;

  @override
  void initState() {
    super.initState();
    historicoFuture = _carregarHistorico();
  }

  Future<List<Map<String, dynamic>>> _carregarHistorico() async {
    final abastecimentos = await abastecimentoService.listarAbastecimentos();
    final veiculos = await veiculoService.listarVeiculos();

    final veiculosMap = {
      for (var veiculo in veiculos) veiculo['id']: veiculo['nome'],
    };

    return abastecimentos.map((abastecimento) {
      return {
        ...abastecimento,
        'veiculoNome':
            veiculosMap[abastecimento['veiculoId']] ?? 'Desconhecido',
      };
    }).toList();
  }

  Future<void> _atualizarLista() async {
    setState(() {
      historicoFuture = _carregarHistorico();
    });
  }

  double _calcularMediaConsumo(List<Map<String, dynamic>> abastecimentos) {
    if (abastecimentos.isEmpty) return 0.0;

    double totalLitros = 0;
    int totalKm = 0;

    for (var i = 0; i < abastecimentos.length - 1; i++) {
      final kmAtual = abastecimentos[i]['quilometragem'] as int;
      final kmAnterior = abastecimentos[i + 1]['quilometragem'] as int;
      totalKm += (kmAtual - kmAnterior);
      totalLitros += abastecimentos[i]['litros'] as double;
    }

    return totalLitros > 0 ? totalKm / totalLitros : 0.0;
  }

  void _excluirAbastecimento(String abastecimentoId) async {
    try {
      await abastecimentoService.excluirAbastecimento(abastecimentoId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Abastecimento excluído com sucesso!')),
      );
      _atualizarLista();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir abastecimento: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Abastecimentos'),
        actions: [
          IconButton(
            icon: Icon(Icons.calculate),
            onPressed: () async {
              final historico = await historicoFuture;
              final mediaConsumo = _calcularMediaConsumo(historico);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Média de Consumo'),
                  content: Text(
                      'A média de consumo é de ${mediaConsumo.toStringAsFixed(2)} km/L'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: historicoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar histórico.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum abastecimento registrado.'));
          }

          final historico = snapshot.data!;
          return ListView.builder(
            itemCount: historico.length,
            itemBuilder: (context, index) {
              final abastecimento = historico[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('Veículo: ${abastecimento['veiculoNome']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data: ${abastecimento['data']}'),
                      Text('Litros: ${abastecimento['litros']} L'),
                      Text(
                          'Quilometragem: ${abastecimento['quilometragem']} km'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _excluirAbastecimento(abastecimento['id']);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
