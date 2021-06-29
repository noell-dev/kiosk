import 'package:flutter/material.dart';
import 'package:kiosk/common/models.dart';

class TransactionsPanel extends StatefulWidget {
  TransactionsPanel({
    Key? key,
  }) : super(key: key);

  @override
  _TransactionsPanelState createState() => _TransactionsPanelState();
}

class _TransactionsPanelState extends State<TransactionsPanel> {
  List<Trans> _transactions = [
    Trans(
      DateTime.now(),
      "customerName",
      "productName",
      4,
      2,
      10,
      2,
      id: 0,
    )
  ];

  @override
  void initState() {
    // TODO: implement getting Transactions

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verlauf:")),
      body: _transactions.length == 0
          ? Center(
              child: Text("Nothing yet"),
            )
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                  "${_transactions[index].customerName}",
                ));
              },
            ),
    );
  }
}
