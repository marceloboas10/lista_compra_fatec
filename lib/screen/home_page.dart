import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_compra/model/lista.dart';
import 'package:lista_compra/provider/lista_provider.dart';
import 'package:lista_compra/widgets/lista_home.dart';
import 'package:lista_compra/widgets/meu_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ListaProvider listaProvider = context.watch<ListaProvider>();
    List<Lista> lista = listaProvider.itensLista;

    return Scaffold(
      appBar: AppBar(
        title:  Text('Minhas Listas',style: GoogleFonts.abel(fontSize: 26, color: Colors.black),),
      ),
      drawer: const MeuDrawer(),
      body: ListView.builder(
        itemCount: listaProvider.itemsListaCount,
        itemBuilder: (context, index) {
          final listaNome = lista[index];
          return ListaHome(
            itens: listaNome.itens,
            nome: listaNome.title,
            idItem: listaNome.id.toString(),
            deletar: () {
              listaProvider.removerLista(index);
            },
            editar: () {
              listaProvider.editarNomeLista(context, listaNome, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          listaProvider.addListaPage(context, listaProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
