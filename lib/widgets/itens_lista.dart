import 'package:flutter/material.dart';

class ItensLista extends StatelessWidget {
  const ItensLista(
      {super.key,
      required this.nome,
      required this.deletar,
      required this.editar,
      required this.concluido,
      required this.onChanged});

  final String nome;
  final VoidCallback deletar;
  final VoidCallback editar;
  final bool concluido;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        nome,
        style: TextStyle(
            decoration:
                concluido ? TextDecoration.lineThrough : TextDecoration.none),
      ),
      leading: Checkbox(value: concluido, onChanged: onChanged),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: editar,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deletar,
          ),
        ],
      ),
    );

    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
    //   child: Row(
    //     children: [
    //       Text(
    //         nome,
    //         style: Theme.of(context).textTheme.titleLarge,
    //       ),
    //       const Spacer(),
    //       IconButton(
    //         onPressed: editar,
    //         icon: const Icon(Icons.edit),
    //       ),
    //       IconButton(
    //         onPressed: deletar,
    //         icon: const Icon(Icons.delete),
    //       ),
    //     ],
    //   ),
    // );
  }
}
