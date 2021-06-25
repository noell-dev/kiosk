import 'package:flutter/material.dart';
import 'package:kiosk/common/models.dart';

class ItemsPanel extends StatefulWidget {
  ItemsPanel({
    Key? key,
  }) : super(key: key);

  @override
  _ItemsPanelState createState() => _ItemsPanelState();
}

class _ItemsPanelState extends State<ItemsPanel> {
  bool _loading = true;
  bool _viewFAB = false;

  List<Item> _items = [Item("Test", 0)];

  @override
  void initState() {
    // TODO: implement getting Items

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
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                  "${_items[index].name}",
                ));
              },
            ),
      floatingActionButton: _viewFAB
          ? FloatingActionButton(
              // TODO: impement adding Items
              onPressed: () {},
              tooltip: 'Add',
              child: Icon(Icons.add),
            )
          : Container(),
    );
  }
}
