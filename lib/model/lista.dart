class Lista {
  String? id;
  String title;
  List<ItemsLista> itens;

  Lista({this.id, required this.title, required this.itens});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'itens': itens.map((item) => item.toJson()).toList()
    };
  }

  factory Lista.fromJson(Map<String, dynamic> json) {
    return Lista(
        id: json['id'],
        title: json['title'],
        itens: List<ItemsLista>.from(
            json['itens'].map((itemJson) => ItemsLista.fromJson(itemJson))));
  }
}

class ItemsLista {
  String? id;
  String nome;
  bool estaFeito;

  ItemsLista({required this.nome, this.estaFeito = false, this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'estaFeito': estaFeito,
    };
  }

  factory ItemsLista.fromJson(Map<String, dynamic> json) {
    return ItemsLista(
        id: json['id'], nome: json['nome'], estaFeito: json['estaFeito']);
  }
}
