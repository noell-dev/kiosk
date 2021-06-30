import 'package:flutter/material.dart';
import 'package:kiosk/common/models.dart';
import 'package:provider/provider.dart';

class TransactionsPanel extends StatefulWidget {
  TransactionsPanel({
    Key? key,
  }) : super(key: key);

  @override
  _TransactionsPanelState createState() => _TransactionsPanelState();
}

class _TransactionsPanelState extends State<TransactionsPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verlauf:")),
      body: Consumer<TransListModel>(
        builder: (context, transList, child) => ListView.builder(
          itemCount: transList.list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                "${transList.list[index].customerName} ",
              ),
              subtitle: Text(
                  "${transList.list[index].quantitiy}x ${transList.list[index].productName} (${transList.list[index].productPrice})"),
              trailing: Text(
                  "${transList.list[index].initalBalance} -> ${transList.list[index].resultingBalance}"),
            );
          },
        ),
      ),
    );
  }
}
