import 'package:flutter/material.dart';
import 'package:lista_compra/provider/lista_provider.dart';
import 'package:provider/provider.dart';

class BarraPesquisa extends StatelessWidget {
  const BarraPesquisa({super.key, required this.buscaItem});

  final TextEditingController buscaItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          Provider.of<ListaProvider>(context, listen: false)
              .filtrarItens(value);
        },
        controller: buscaItem,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(maxHeight: 45, maxWidth: 280),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          hintText: 'Pesquisar',
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
