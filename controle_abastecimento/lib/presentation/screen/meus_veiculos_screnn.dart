import 'package:controle_abastecimento/data/firebase/veiculo_service.dart';
import 'package:controle_abastecimento/data/firebase/abastecimento_service.dart';
import 'package:controle_abastecimento/presentation/screen/cadastrar_abastecimento_screen.dart';
import 'package:flutter/material.dart';
import 'editar_veiculos_screen.dart';

class MeusVeiculosScreen extends StatefulWidget {
  @override
  _MeusVeiculosScreenState createState() => _MeusVeiculosScreenState();
}

class _MeusVeiculosScreenState extends State<MeusVeiculosScreen> {
  final VeiculoService veiculoService = VeiculoService();
  final AbastecimentoService abastecimentoService = AbastecimentoService();
  late Future<List<Map<String, dynamic>>> veiculosFuture;

  @override
  void initState() {
    super.initState();
    veiculosFuture = veiculoService.listarVeiculos();
  }

  Future<void> _atualizarLista() async {
    setState(() {
      veiculosFuture = veiculoService.listarVeiculos();
    });
  }

  Future<void> _calcularMediaConsumo(
      BuildContext context, String veiculoId) async {
    try {
      final abastecimentos =
          await abastecimentoService.listarAbastecimentos(veiculoId);

      if (abastecimentos.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Não há dados suficientes para calcular a média de consumo.')),
        );
        return;
      }

      double totalKm = 0;
      double totalLitros = 0;

      for (var i = 0; i < abastecimentos.length - 1; i++) {
        final kmAtual = abastecimentos[i]['quilometragem'] as int;
        final kmAnterior = abastecimentos[i + 1]['quilometragem'] as int;

        totalKm += (kmAtual - kmAnterior).toDouble();
        totalLitros += abastecimentos[i]['litros'] as double;
      }

      final mediaConsumo = totalKm / totalLitros;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Média de consumo: ${mediaConsumo.toStringAsFixed(2)} km/L')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao calcular média de consumo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Veículos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: veiculosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar veículos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum veículo cadastrado.'));
          }

          final veiculos = snapshot.data!;
          return ListView.builder(
            itemCount: veiculos.length,
            itemBuilder: (context, index) {
              final veiculo = veiculos[index];
              return Card(
                child: ListTile(
                  title: Text(veiculo['nome']),
                  subtitle: Text('${veiculo['modelo']} - ${veiculo['placa']}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String escolha) async {
                      if (escolha == 'Editar') {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarVeiculoScreen(
                              id: veiculo['id'],
                              nome: veiculo['nome'],
                              modelo: veiculo['modelo'],
                              ano: veiculo['ano'],
                              placa: veiculo['placa'],
                            ),
                          ),
                        );
                        _atualizarLista();
                      } else if (escolha == 'Excluir') {
                        await veiculoService.excluirVeiculo(veiculo['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Veículo excluído com sucesso!')),
                        );
                        _atualizarLista();
                      } else if (escolha == 'Cadastrar Abastecimento') {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastrarAbastecimentoScreen(
                              veiculoId: veiculo['id'],
                              veiculoNome: veiculo['nome'],
                            ),
                          ),
                        );
                      } else if (escolha == 'Calcular Média de Consumo') {
                        await _calcularMediaConsumo(context, veiculo['id']);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'Editar',
                        child: Text('Editar'),
                      ),
                      PopupMenuItem(
                        value: 'Excluir',
                        child: Text('Excluir'),
                      ),
                      PopupMenuItem(
                        value: 'Cadastrar Abastecimento',
                        child: Text('Cadastrar Abastecimento'),
                      ),
                      PopupMenuItem(
                        value: 'Calcular Média de Consumo',
                        child: Text('Calcular Média de Consumo'),
                      ),
                    ],
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
