import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Modelo de dados
class ShoppingList {
  String id;
  String name;
  List<ShoppingItem> items;

  ShoppingList({required this.id, required this.name, required this.items});
}

class ShoppingItem {
  String name;
  int quantity;
  bool isBought;

  ShoppingItem(
      {required this.name, required this.quantity, this.isBought = false});
}

// Provider para gerenciar o estado
class ShoppingListsProvider extends ChangeNotifier {
  List<ShoppingList> _shoppingLists = [];

  List<ShoppingList> get shoppingLists => _shoppingLists;

  void addShoppingList(ShoppingList shoppingList) {
    _shoppingLists.add(shoppingList);
    notifyListeners();
  }

  void editShoppingList(int index, ShoppingList shoppingList) {
    _shoppingLists[index] = shoppingList;
    notifyListeners();
  }

  void removeShoppingList(int index) {
    _shoppingLists.removeAt(index);
    notifyListeners();
  }

  void addItemToList(ShoppingItem item) {
    final shoppingListIndex =
        _shoppingLists.indexWhere((list) => list.id == list.id);
    if (shoppingListIndex != -1) {
      _shoppingLists[shoppingListIndex].items.add(item);
      notifyListeners();
    }
  }

  void editItem(int index, ShoppingItem item) {
    _shoppingLists.forEach((list) {
      final itemIndex = list.items.indexOf(item);
      if (itemIndex != -1) {
        list.items[index] = item;
      }
    });
    notifyListeners();
  }
}

// Tela principal
class ShoppingListsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoppingListsProvider = context.watch<ShoppingListsProvider>();
    List<ShoppingList> shoppingLists = shoppingListsProvider.shoppingLists;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
      ),
      body: ListView.builder(
        itemCount: shoppingLists.length,
        itemBuilder: (context, index) {
          final shoppingList = shoppingLists[index];
          return ListTile(
            title: Text(shoppingList.name),
            onTap: () {
              _viewShoppingItems(context, shoppingList);
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                shoppingListsProvider.removeShoppingList(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewShoppingList(context, shoppingListsProvider);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _createNewShoppingList(
      BuildContext context, ShoppingListsProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        String newListName = '';
        return AlertDialog(
          title: Text('Nova Lista de Compras'),
          content: TextField(
            onChanged: (value) {
              newListName = value;
            },
            decoration: InputDecoration(
              hintText: 'Nome da lista',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (newListName.isNotEmpty) {
                  provider.addShoppingList(ShoppingList(
                      id: UniqueKey().toString(),
                      name: newListName,
                      items: []));
                  Navigator.pop(context);
                }
              },
              child: Text('Criar'),
            ),
          ],
        );
      },
    );
  }

  void _viewShoppingItems(BuildContext context, ShoppingList shoppingList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShoppingItemListScreen(items: shoppingList.items),
      ),
    );
  }
}

// Tela para visualizar e editar itens da lista de compras
class ShoppingItemListScreen extends StatelessWidget {
  final List<ShoppingItem> items;

  ShoppingItemListScreen({required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itens da Lista'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addItem(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Quantidade: ${item.quantity}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _editItem(context, index, item);
              },
            ),
          );
        },
      ),
    );
  }

  void _addItem(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _quantityController = TextEditingController();

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
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Item',
                ),
              ),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final String name = _nameController.text.trim();
                final String quantityString = _quantityController.text.trim();
                final int quantity =
                    quantityString.isNotEmpty ? int.parse(quantityString) : 1;

                if (name.isNotEmpty && quantity > 0) {
                  final ShoppingItem newItem =
                      ShoppingItem(name: name, quantity: quantity);
                  Provider.of<ShoppingListsProvider>(context, listen: false)
                      .addItemToList(newItem);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Por favor, preencha o nome do item e a quantidade.'),
                    ),
                  );
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _editItem(BuildContext context, int index, ShoppingItem item) {
    final TextEditingController _nameController =
        TextEditingController(text: item.name);
    final TextEditingController _quantityController =
        TextEditingController(text: item.quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Item',
                ),
              ),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final String name = _nameController.text.trim();
                final String quantityString = _quantityController.text.trim();
                final int quantity = quantityString.isNotEmpty
                    ? int.parse(quantityString)
                    : item.quantity;

                if (name.isNotEmpty && quantity > 0) {
                  final ShoppingItem editedItem =
                      ShoppingItem(name: name, quantity: quantity);
                  Provider.of<ShoppingListsProvider>(context, listen: false)
                      .editItem(index, editedItem);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Por favor, preencha o nome do item e a quantidade.'),
                    ),
                  );
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ShoppingListsProvider(),
      child: MaterialApp(
        title: 'Lista de Compras',
        home: ShoppingListsScreen(),
      ),
    ),
  );
}
