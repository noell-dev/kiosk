import 'package:flutter/material.dart';
import 'package:kiosk/common/database.dart';
import 'package:kiosk/common/models.dart';

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

class ItemsPanel extends StatefulWidget {
  ItemsPanel({
    Key? key,
  }) : super(key: key);

  @override
  _ItemsPanelState createState() => _ItemsPanelState();
}

class _ItemsPanelState extends State<ItemsPanel> {
  bool _loading = true;
  bool _viewFAB = true;

  List<Item> _items = [Item("Test", 0)];

  void _getItems() async {
    List<Item> _temp = await getItems();
    if (_temp.isNotEmpty) {
      setState(() {
        _loading = false;
        _items = _temp;
      });
    } else {
      setState(() {
        _loading = false;
        _items = _temp;
      });
    }
  }

  @override
  void initState() {
    _getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Waren:")),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _items.length == 0
              ? Center(
                  child: Text("Keine Items bisher."),
                )
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextButton(
                              child: Text("1x"),
                              // ToDo: Add "buying" of items
                              onPressed: () {},
                              style: ButtonStyle(backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.amber.withOpacity(0.5);
                                  }
                                  return Colors
                                      .amber; // Use the component's default.
                                },
                              )),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextButton(
                              child: Text("5x"),
                              // ToDo: Add "buying" of items
                              onPressed: () {},
                              style: ButtonStyle(backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.amber.withOpacity(0.5);
                                  }
                                  return Colors
                                      .amber; // Use the component's default.
                                },
                              )),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextButton(
                              child: Text("10x"),
                              // ToDo: Add "buying" of items
                              onPressed: () {},
                              style: ButtonStyle(backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.amber.withOpacity(0.5);
                                  }
                                  return Colors
                                      .amber; // Use the component's default.
                                },
                              )),
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        "${_items[index].name}",
                      ),
                      subtitle: Text("${_items[index].price} €"),
                    );
                  },
                ),
      floatingActionButton: _viewFAB
          ? FloatingActionButton(
              onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AddItemsOverlay())
                  .then((value) => _getItems()),
              tooltip: 'Add',
              child: Icon(Icons.add),
            )
          : Container(),
    );
  }
}

class AddItemsOverlay extends StatefulWidget {
  AddItemsOverlay({
    Key? key,
  }) : super(key: key);

  @override
  _AddItemsOverlayState createState() => _AddItemsOverlayState();
}

class _AddItemsOverlayState extends State<AddItemsOverlay> {
  final _itemKey = GlobalKey<FormState>();

  String name = "";
  double price = 0;

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Item hinzufügen"),
      content: Form(
        key: _itemKey,
        child: Column(
          children: [
            // ToDo: Add texts
            TextFormField(
              onSaved: (String? value) {
                name = value!;
              },
              validator: (String? value) {
                if (value?.isEmpty ?? false) {
                  return "Bitte Text eingeben";
                }
                return null;
              },
            ),
            // ToDo: Add texts
            TextFormField(
              onSaved: (String? value) {
                price = double.parse(value!);
              },
              validator: (String? value) {
                if (value == null) {
                  return "Bitte eine Zahl eingeben:";
                } else {
                  if (value.isEmpty || !isNumeric(value)) {
                    return "Bitte eine Zahl eingeben";
                  }
                  return null;
                }
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (_itemKey.currentState?.validate() ?? false) {
                    _itemKey.currentState?.save();
                    insertItem("items", Item(name, price));
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Speichern"))
          ],
        ),
      ),
    );
  }
}
