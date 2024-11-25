import 'package:controle_abastecimento/data/auth_service.dart';
import 'package:controle_abastecimento/presentation/screen/historico_abastecimentos_screen.dart';
import 'package:controle_abastecimento/presentation/screen/login_screen.dart';
import 'package:controle_abastecimento/presentation/screen/meus_veiculos_screnn.dart';
import 'package:controle_abastecimento/presentation/screen/perfil_screen.dart';
import 'package:flutter/material.dart';
import 'adicionar_veiculo_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Abastecimento'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Meus Veículos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeusVeiculosScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Adicionar Veículo'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdicionarVeiculoScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Histórico de Abastecimentos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HistoricoAbastecimentosScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PerfilScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                await AuthService().logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Bem-vindo ao Controle de Abastecimento!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
