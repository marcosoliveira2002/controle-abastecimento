import 'package:cloud_firestore/cloud_firestore.dart';

class AbastecimentoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> cadastrarAbastecimento(
      String veiculoId, double litros, int quilometragem, DateTime data) async {
    try {
      await _firestore.collection('abastecimentos').add({
        'veiculoId': veiculoId,
        'litros': litros,
        'quilometragem': quilometragem,
        'data': data.toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Erro ao cadastrar abastecimento: $e");
      throw Exception('Erro ao cadastrar abastecimento: $e');
    }
  }


Future<List<Map<String, dynamic>>> listarAbastecimentos([String? veiculoId]) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (veiculoId != null) {
        // Filtra os abastecimentos pelo veículo
        snapshot = await _firestore
            .collection('abastecimentos')
            .where('veiculoId', isEqualTo: veiculoId)
            .get();
      } else {
        // Retorna todos os abastecimentos
        snapshot = await _firestore.collection('abastecimentos').get();
      }

      return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
    } catch (e) {
      throw Exception('Erro ao listar abastecimentos: $e');
    }
  }



  Future<void> excluirAbastecimento(String abastecimentoId) async {
    try {
      await _firestore.collection('abastecimentos').doc(abastecimentoId).delete();
    } catch (e) {
      print("Erro ao excluir abastecimento: $e");
      throw Exception('Erro ao excluir abastecimento: $e');
    }
  }
}
