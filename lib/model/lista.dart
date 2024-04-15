class Lista {
   String? id;
   String title;
  List<ItemsLista> itens;

  Lista({this.id, required this.title, required this.itens});
}

class ItemsLista {
  String? id;
  String nome;
  bool estaFeito;

  ItemsLista({required this.nome, this.estaFeito = false, this.id});
}
