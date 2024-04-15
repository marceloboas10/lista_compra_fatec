import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_compra/widgets/formulario_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_basket_outlined,
              size: 80,
              color: Colors.black,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Minhas Compras',
              style: GoogleFonts.abel(fontSize: 35, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  FormularioLogin(),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
