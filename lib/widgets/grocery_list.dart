import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/Screens/new_item_screen.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  GroceryList({Key? key}) : super(key: key);

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  @override
  void initState() {
    // TODO: implement initState
    _loadedItems();
  }

  List<GroceryItem> _groceryItems = [];
  var _loading = true;

  void _loadedItems() async {
    final url = Uri.https(
        'flutter-prep-5e382-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);
    print(response.body);
    final Map<String, dynamic> listdata = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final items in listdata.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == items.value['category'])
          .value;
      loadedItems.add(
        GroceryItem(
            id: items.key,
            name: items.value['name'],
            quantity: (items.value['quantity']),
            category: category),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
      _loading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (context) => NewItemScreen()));
    setState(() {
      _groceryItems.add(newItem!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
        child: CircularProgressIndicator(
      backgroundColor: Colors.white,
    ));
    if (!_loading) {
      content = ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, i) {
            return ListTile(
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[i].category.color,
              ),
              title: Text(
                _groceryItems[i].name,
                style: TextStyle(color: Colors.white),
              ),
              trailing: Text(
                _groceryItems[i].quantity.toString(),
                style: TextStyle(color: Colors.white),
              ),
            );
          });
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Your Groceries",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              _addItem();
            },
            icon: Icon(Icons.add, color: Colors.white),
          )
        ],
      ),
      body: content,
    );
  }
}
