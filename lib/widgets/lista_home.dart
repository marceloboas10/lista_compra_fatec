import 'package:flutter/material.dart';
import 'package:lista_compra/model/lista.dart';
import 'package:lista_compra/screen/itens_lista_page.dart';

class ListaHome extends StatelessWidget {
  const ListaHome(
      {super.key,
      required this.nome,
      required this.deletar,
      required this.editar,
      required this.itens,
      required this.idItem});

  final String nome;
  final VoidCallback deletar;
  final VoidCallback editar;
  final List<ItemsLista> itens;
  final String idItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 271,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItensListaPage(
                      itens: itens,
                      nome: nome,
                      idItem: idItem,
                    ),
                  ),
                );
              },
              child: Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                nome,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: editar,
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: deletar,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 30,
            ),
          )
        ],
      ),
    );

    
  }
}
