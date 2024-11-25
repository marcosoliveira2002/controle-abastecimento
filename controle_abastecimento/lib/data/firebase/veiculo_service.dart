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


  Future<List<Map<String, dynamic>>> listarVeiculos() async {
    try {
      final querySnapshot = await _firestore
          .collection('veiculos')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id, 
          ...data,
        };
      }).toList();
    } catch (e) {
      print("Erro ao listar veículos: $e");
      throw Exception('Erro ao listar veículos: $e');
    }
  }

  
  Future<void> editarVeiculo(String id, String nome, String modelo, String ano, String placa) async {
    try {
      await _firestore.collection('veiculos').doc(id).update({
        'nome': nome,
        'modelo': modelo,
        'ano': ano,
        'placa': placa,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Erro ao editar veículo: $e");
      throw Exception('Erro ao editar veículo: $e');
    }
  }

  
  Future<void> excluirVeiculo(String id) async {
    try {
      await _firestore.collection('veiculos').doc(id).delete();
    } catch (e) {
      print("Erro ao excluir veículo: $e");
      throw Exception('Erro ao excluir veículo: $e');
    }
  }
}
