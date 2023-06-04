import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var enteredName = " ";
  var enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables];

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      // .validate() executes the validator functions
      _formKey.currentState?.save();
      Navigator.of(context).pop(GroceryItem(
          id: DateTime.now().toString(),
          name: enteredName,
          quantity: enteredQuantity,
          category: _selectedCategory!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // instead of TextField()
            TextFormField(
              maxLines: 1,
              decoration: InputDecoration(
                label: Text("Name"),
              ),
              validator: (value) {
                if (value == null ||
                    value!.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 20) {
                  return "Enter a valid Value";
                }
                return null;
              },
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                enteredName = value;
              },
            ),
            SizedBox(
              height: 1,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(label: Text("Quantity")),
                    initialValue: enteredQuantity.toString(),
                    validator: (value) {
                      int? val = int.tryParse(value!);
                      if (val == null || val == 0 || val > 10 || val < 0) {
                        return "Add a suitable value";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value == null) {
                        return;
                      }
                      enteredQuantity = int.tryParse(value)!;
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        _selectedCategory = value;
                      },
                      decoration: InputDecoration(label: Text("Type"))),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                    },
                    style: ButtonStyle(),
                    child: Text(
                      "Reset",
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontSize: 18),
                    )),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: _saveItem,
                  child: Text(
                    "Add Item",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
