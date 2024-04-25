import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_compra/screen/login_page.dart';

class MeuDrawer extends StatelessWidget {
  const MeuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  // backgroundImage: AssetImage(
                  //     'assets/avatar.png'), // Adicione sua imagem de avatar aqui
                ),
                SizedBox(height: 10),
                Text(
                  'Nome do Usuário',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'usuario@email.com',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre o Deseenvolvedor'),
            onTap: () {
              //  _mostraDialogo(context);
            },
          ),
          ListTile(
            title: const Text('Sair'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
