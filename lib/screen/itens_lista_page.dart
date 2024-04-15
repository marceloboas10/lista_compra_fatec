import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_compra/model/lista.dart';
import 'package:lista_compra/provider/lista_provider.dart';
import 'package:lista_compra/widgets/itens_lista.dart';
import 'package:provider/provider.dart';

class ItensListaPage extends StatelessWidget {
  const ItensListaPage(
      {super.key, this.nome, required this.itens, required this.idItem});
  final String? nome;
  final String idItem;
  final List<ItemsLista> itens;

  @override
  Widget build(BuildContext context) {
    final ListaProvider itensListaProvider = context.watch<ListaProvider>();

    return Scaffold(
        appBar: AppBar(
          title: Text(nome!),
          actions: [
            IconButton(
                onPressed: () {
                  itensListaProvider.addItemLista(context, idItem);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Total Itens: ${itens.length}',
                style: GoogleFonts.abel(fontSize: 26, color: Colors.black),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: itens.length,
                itemBuilder: (context, index) {
                  final item = itens[index];
                  return ItensLista(
                    nome: item.nome,
                    deletar: () {
                      //  itensListaProvider.removerItem(index);
                    },
                    editar: () {
                      itensListaProvider.editarItemLista(context, item, index);
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
