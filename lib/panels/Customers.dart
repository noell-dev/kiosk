import 'package:flutter/material.dart';
import 'package:kiosk/common/database.dart';
import 'package:kiosk/common/models.dart';

class CustomersPanel extends StatefulWidget {
  CustomersPanel({
    Key? key,
  }) : super(key: key);

  @override
  _CustomersPanelState createState() => _CustomersPanelState();
}

class _CustomersPanelState extends State<CustomersPanel> {
  Customer _currentCustomer = Customer("nicht_ausgewählt", 0);
  bool _customerSelected = false;
  bool _loading = true;
  bool _viewFAB = true;
  bool _noItems = false;

  List<Customer> _customers = [Customer("Test", 0)];

  void _getCustomers() async {
    List<Customer> _temp = await getCustomers();
    if (_temp.isNotEmpty) {
      setState(() {
        _loading = false;
        _noItems = false;
        _customers = _temp;
      });
    } else {
      setState(() {
        _loading = false;
        _noItems = true;
        _customers = _temp;
      });
    }
  }

  @override
  void initState() {
    _getCustomers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: _customerSelected
                  ? () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              EditBalanceOverlay(customer: _currentCustomer))
                      .then((value) => _getCustomers())
                  : () {},
              icon: Icon(Icons.edit))
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_customerSelected
                ? "Kunde: ${_currentCustomer.name}"
                : "Kein Kunde ausgewählt"),
            Text(_customerSelected
                ? "Kontostand: ${_currentCustomer.balance}€"
                : "Kontostand: --€"),
          ],
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _customers.length == 0
              ? Center(child: Text("Noch keine Kunden"))
              : ListView.builder(
                  itemCount: _customers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "${_customers[index].name}",
                      ),
                      subtitle: Text("${_customers[index].balance}"),
                      onTap: () {
                        setState(() {
                          _currentCustomer = _customers[index];
                          _customerSelected = true;
                        });
                      },
                    );
                  },
                ),
      floatingActionButton: _viewFAB
          ? FloatingActionButton(
              onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          AddCustomersOverlay(customers: _customers))
                  .then((value) => _getCustomers()),
              tooltip: ' Add',
              child: Icon(Icons.add),
            )
          : Container(),
    );
  }
}

class AddCustomersOverlay extends StatefulWidget {
  AddCustomersOverlay({
    Key? key,
    required this.customers,
  }) : super(key: key);

  final List<Customer> customers;

  @override
  _AddCustomersOverlayState createState() => _AddCustomersOverlayState();
}

class _AddCustomersOverlayState extends State<AddCustomersOverlay> {
  final _customerKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Kunden hinzufügen"),
      content: Form(
        key: _customerKey,
        child: Column(
          children: [
            // ToDo: Add texts
            TextFormField(
              onSaved: (String? value) {
                insertItem("customers", Customer(value!, 0));
                Navigator.of(context).pop();
              },
              validator: (String? value) {
                if (value?.isEmpty ?? false) {
                  return "Bitte Text eingeben";
                } else if (widget.customers.contains(value!)) {
                  return "Kunde bereits vorhanden";
                }
                return null;
              },
            ),

            ElevatedButton(
                onPressed: () {
                  if (_customerKey.currentState?.validate() ?? false) {
                    _customerKey.currentState?.save();
                  }
                },
                child: Text("Speichern"))
          ],
        ),
      ),
    );
  }
}

class EditBalanceOverlay extends StatefulWidget {
  EditBalanceOverlay({
    Key? key,
    required this.customer,
  }) : super(key: key);

  final Customer customer;

  @override
  _EditBalanceOverlayState createState() => _EditBalanceOverlayState();
}

class _EditBalanceOverlayState extends State<EditBalanceOverlay> {
  final _balanceKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Guthaben von ${widget.customer}"),
      content: Form(
        key: _balanceKey,
        child: Column(
          children: [
            // ToDo: Add texts
            TextFormField(
              onSaved: (String? value) {
                updateBalance(
                    Customer(widget.customer.name, double.parse(value!)));
                Navigator.of(context).pop();
              },
              validator: (String? value) {
                if (value?.isEmpty ?? false) {
                  return "Bitte Text eingeben";
                }
                return null;
              },
            ),

            ElevatedButton(
                onPressed: () {
                  if (_balanceKey.currentState?.validate() ?? false) {
                    _balanceKey.currentState?.save();
                  }
                },
                child: Text("Speichern"))
          ],
        ),
      ),
    );
  }
}
