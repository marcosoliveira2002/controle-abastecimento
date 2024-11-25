import 'package:cloud_firestore/cloud_firestore.dart';

class VeiculoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> cadastrarVeiculo(String nome, String modelo, String ano, String placa) async {
    try {
      await _firestore.collection('veiculos').add({
        'nome': nome,
        'modelo': modelo,
        'ano': ano,
        'placa': placa,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Erro ao cadastrar veículo: $e");
      throw Exception('Erro ao cadastrar veículo: $e');
    }
  }
}

