import 'package:flutter/material.dart';
import 'package:lista_compra/model/lista.dart';
import 'package:lista_compra/provider/lista_provider.dart';
import 'package:lista_compra/widgets/barra_pesquisa.dart';
import 'package:lista_compra/widgets/itens_lista.dart';
import 'package:provider/provider.dart';

class ItensListaPage extends StatelessWidget {
  ItensListaPage(
      {super.key, this.nome, required this.itens, required this.idItem});

  final String? nome;
  final String idItem;
  final List<ItemsLista> itens;
  final TextEditingController nomeItem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ListaProvider itensListaProvider = context.watch<ListaProvider>();

    List<ItemsLista> itensFiltrados = itens
        .where((item) =>
            item.nome.toLowerCase().startsWith(nomeItem.text.toLowerCase()))
        .toList();

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
            BarraPesquisa(
              buscaItem: nomeItem,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: itensFiltrados.length,
                itemBuilder: (context, index) {
                  final item = itensFiltrados[index];
                  return ItensLista(
                    nome: item.nome,
                    concluido: item.estaFeito,
                    onChanged: (value) {
                      itensListaProvider.marcarItemConcluido(
                          index, idItem, value!);
                    },
                    deletar: () {
                      itensListaProvider.removeItem(index, idItem);
                    },
                    editar: () {
                      itensListaProvider.editarItemLista(
                          context, item, index, idItem);
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
