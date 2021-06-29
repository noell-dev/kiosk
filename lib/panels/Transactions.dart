import 'package:flutter/material.dart';
import 'package:kiosk/common/database.dart';
import 'package:kiosk/common/models.dart';

class TransactionsPanel extends StatefulWidget {
  TransactionsPanel({
    Key? key,
  }) : super(key: key);

  @override
  _TransactionsPanelState createState() => _TransactionsPanelState();
}

class _TransactionsPanelState extends State<TransactionsPanel> {
  bool _loading = true;
  // ToDo: https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple

  List<Trans> _transactions = [];
  void _getTransactions() async {
    List<Trans> _temp = await getTransactions();
    if (_temp.isNotEmpty) {
      setState(() {
        _loading = false;
        _transactions = _temp;
      });
    } else {
      setState(() {
        _loading = false;
        _transactions = _temp;
      });
    }
  }

  @override
  void initState() {
    _getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verlauf:")),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _transactions.length == 0
              ? Center(
                  child: Text("Nothing yet"),
                )
              : ListView.builder(
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "${_transactions[index].customerName} ",
                      ),
                      subtitle: Text(
                          "${_transactions[index].quantitiy}x ${_transactions[index].productName} (${_transactions[index].productPrice})"),
                      trailing: Text(
                          "${_transactions[index].initalBalance} -> ${_transactions[index].resultingBalance}"),
                    );
                  },
                ),
    );
  }
}
