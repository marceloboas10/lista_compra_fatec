import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lista_compra/model/lista.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaProvider extends ChangeNotifier {
  final List<Lista> _lista = [];

  List<Lista> get itensLista {
    return [..._lista];
  }

  int get itemsListaCount {
    return _lista.length;
  }

  // Método para salvar a lista no SharedPreferences
  Future<void> salvarLista() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String listaJson =
        json.encode(_lista.map((e) => e.toJson()).toList());
    await prefs.setString('lista_compra', listaJson);
    print('lista salva');
  }

// Método para carregar a lista do SharedPreferences
  Future<void> carregarLista() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? listaJson = prefs.getString('lista_compra');
    if (listaJson != null) {
      final List<dynamic> listaMap = json.decode(listaJson);
      _lista.clear();
      _lista.addAll(listaMap.map((e) => Lista.fromJson(e)).toList());
      print('lista carregada');
    }
  }

  void marcarItemConcluido(int index, String listaId, bool concluido) {
    final listaIndex = _lista.indexWhere((lista) => lista.id == listaId);
    if (listaIndex != -1 && index < _lista[listaIndex].itens.length) {
      _lista[listaIndex].itens[index].estaFeito = concluido;
      notifyListeners();
    }
  }

  void addLista(Lista lista) {
    _lista.add(lista);
    notifyListeners();
  }

  void editarLista(int index, Lista lista) {
    String listaId = _lista[index].id.toString();

    _lista[index].title = lista.title;
    _lista[index].id = listaId;
    notifyListeners();
  }

  void removerLista(int index) {
    _lista.removeAt(index);
    notifyListeners();
  }

  void addItem(ItemsLista item) {
    final itemIndexLista = _lista.indexWhere((lista) => lista.id == item.id);

    if (itemIndexLista != -1) {
      _lista[itemIndexLista].itens.add(item);
      notifyListeners();
    }
  }

  void editItem(int index, ItemsLista item, String listaId) {
    final listaIndex = _lista.indexWhere((lista) => lista.id == listaId);
    if (listaIndex != -1) {
      _lista[listaIndex].itens[index] = item;
      notifyListeners();
    }
  }

  void filtrarItens(String nomeItem) {
    notifyListeners();
  }

  void addListaPage(BuildContext context, ListaProvider lista) {
    final TextEditingController nameListaController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Lista'),
          content: TextField(
            controller: nameListaController,
            decoration: const InputDecoration(hintText: 'Nome da lista'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
                onPressed: () {
                  if (nameListaController.text.isNotEmpty) {
                    lista.addLista(
                      Lista(
                        id: UniqueKey().toString(),
                        title: nameListaController.text,
                        itens: [],
                      ),
                    );
                    salvarLista();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Criar'))
          ],
        );
      },
    );
  }

  void editarNomeLista(BuildContext context, Lista lista, int index) {
    final TextEditingController _nomeListaController =
        TextEditingController(text: lista.title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar lista'),
          content: TextField(
            controller: _nomeListaController,
            decoration: const InputDecoration(hintText: 'Nome da lista'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final String nome = _nomeListaController.text;
                if (nome.isNotEmpty) {
                  final Lista editarNomeLista = Lista(title: nome, itens: []);
                  Provider.of<ListaProvider>(context, listen: false)
                      .editarLista(index, editarNomeLista);
                  Navigator.pop(context);
                }
              },
              child: const Text('Editar'),
            ),
          ],
        );
      },
    );
  }

  void addItemLista(BuildContext context, String idItem) {
    final TextEditingController nomeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Item',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final String nome = nomeController.text.trim();

                if (nome.isNotEmpty) {
                  final ItemsLista addItem = ItemsLista(nome: nome, id: idItem);
                  Provider.of<ListaProvider>(context, listen: false)
                      .addItem(addItem);
                  salvarLista();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, preencha o nome do item e a quantidade.'),
                    ),
                  );
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void editarItemLista(
      BuildContext context, ItemsLista item, int index, String listaId) {
    final TextEditingController nomeListaController =
        TextEditingController(text: item.nome);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar item'),
          content: TextField(
            controller: nomeListaController,
            decoration: const InputDecoration(hintText: 'Nome do item'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final String nome = nomeListaController.text;
                if (nome.isNotEmpty) {
                  final ItemsLista editarNomeLista =
                      ItemsLista(nome: nome, id: item.id);
                  Provider.of<ListaProvider>(context, listen: false)
                      .editItem(index, editarNomeLista, listaId);
                  Navigator.pop(context);
                }
              },
              child: const Text('Editar'),
            ),
          ],
        );
      },
    );
  }

  void removeItem(int index, String listaId) {
    final listaIndex = _lista.indexWhere((lista) => lista.id == listaId);
    if (listaIndex != -1) {
      _lista[listaIndex].itens.removeAt(index);
      notifyListeners();
    }
  }
}



// Provider para gerenciar o estado
// class ShoppingListsProvider extends ChangeNotifier {
//   List<ShoppingList> _shoppingLists = [];

//   List<ShoppingList> get shoppingLists => _shoppingLists;

//   void addShoppingList(ShoppingList shoppingList) {
//     _shoppingLists.add(shoppingList);
//     notifyListeners();
//   }

//   void editShoppingList(int index, ShoppingList shoppingList) {
//     _shoppingLists[index] = shoppingList;
//     notifyListeners();
//   }

//   void removeShoppingList(int index) {
//     _shoppingLists.removeAt(index);
//     notifyListeners();
//   }

//   void addItemToList(ShoppingItem item) {
//     final shoppingListIndex =
//         _shoppingLists.indexWhere((list) => list.id == list.id);
//     if (shoppingListIndex != -1) {
//       _shoppingLists[shoppingListIndex].items.add(item);
//       notifyListeners();
//     }
//   }

//   void editItem(int index, ShoppingItem item) {
//     _shoppingLists.forEach((list) {
//       final itemIndex = list.items.indexOf(item);
//       if (itemIndex != -1) {
//         list.items[index] = item;
//       }
//     });
//     notifyListeners();
//   }
// }

// void _createNewShoppingList(
//       BuildContext context, ShoppingListsProvider provider) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         String newListName = '';
//         return AlertDialog(
//           title: Text('Nova Lista de Compras'),
//           content: TextField(
//             onChanged: (value) {
//               newListName = value;
//             },
//             decoration: InputDecoration(
//               hintText: 'Nome da lista',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancelar'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (newListName.isNotEmpty) {
//                   provider.addShoppingList(ShoppingList(
//                       id: UniqueKey().toString(),
//                       name: newListName,
//                       items: []));
//                   Navigator.pop(context);
//                 }
//               },
//               child: Text('Criar'),
//             ),
//           ],
//         );
//       },
//     );
//   }


 