import 'package:flutter/material.dart';
import 'package:kiosk/common/models.dart';

class CustomersPanel extends StatefulWidget {
  CustomersPanel({
    Key? key,
  }) : super(key: key);

  @override
  _CustomersPanelState createState() => _CustomersPanelState();
}

class _CustomersPanelState extends State<CustomersPanel> {
  int _counter = 0;
  Customer _currentCustomer = Customer("nicht_ausgewählt", 0);
  bool _customerSelected = false;
  bool _loading = true;
  bool _viewFAB = false;

  List<Customer> _customers = [Customer("Test", 0)];

  @override
  void initState() {
    // TODO: implement getting customers

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_customerSelected
                ? "Kunde: ${_currentCustomer.name}"
                : "Kein Kunde ausgewählt"),
            Text(_customerSelected
                ? "Kontostand: ${_currentCustomer.balance}€"
                : "Kontostand: --€")
          ],
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                  "${_customers[index].name}",
                ));
              },
            ),
      floatingActionButton: _viewFAB
          ? FloatingActionButton(
              // TODO: impement adding customers
              onPressed: () {},
              tooltip: 'Increment',
              child: Icon(Icons.add),
            )
          : Container(),
    );
  }
}
