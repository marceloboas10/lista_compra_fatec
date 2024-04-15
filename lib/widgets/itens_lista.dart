import 'package:flutter/material.dart';

class ItensLista extends StatelessWidget {
  const ItensLista(
      {super.key,
      required this.nome,
      required this.deletar,
      required this.editar});

  final String nome;
  final VoidCallback deletar;
  final VoidCallback editar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Row(
        children: [
          Text(
            nome,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
          IconButton(
            onPressed: editar,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: deletar,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
