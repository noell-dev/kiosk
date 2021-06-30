import 'package:flutter/material.dart';
import 'package:kiosk/common/database.dart';
import 'package:kiosk/common/models.dart';
import 'package:kiosk/panels/Items.dart';
import 'package:provider/provider.dart';

class CustomersPanel extends StatefulWidget {
  CustomersPanel({
    Key? key,
  }) : super(key: key);

  @override
  _CustomersPanelState createState() => _CustomersPanelState();
}

class _CustomersPanelState extends State<CustomersPanel> {
  bool _viewFAB = true;

  List<Customer> _customers = [Customer("Test", 0)];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CustomerListModel>(context, listen: false).reloadCustomerList();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<CustomerListModel>(
              builder: (context, customerModel, child) => IconButton(
                  onPressed: customerModel.cc.name != "_null_"
                      ? () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              EditBalanceOverlay(customer: customerModel.cc))
                      : () {},
                  icon: Icon(Icons.edit)))
        ],
        title: Consumer<CustomerListModel>(
            builder: (context, customerModel, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(customerModel.cc.name != "_null_"
                  ? "Kunde: ${customerModel.cc.name}"
                  : "Kein Kunde ausgewählt"),
              Text(customerModel.cc.name != "_null_"
                  ? "Kontostand: ${customerModel.cc.balance}€"
                  : "Kontostand: --€"),
            ],
          );
        }),
      ),
      body: Consumer<CustomerListModel>(
        builder: (context, consumerList, child) => ListView.builder(
          itemCount: consumerList.list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                "${consumerList.list[index].name}",
              ),
              subtitle: Text("${consumerList.list[index].balance}"),
              onTap: () {
                Provider.of<CustomerListModel>(context, listen: false)
                    .updateCC(consumerList.list[index]);
                Provider.of<TransListModel>(context, listen: false)
                    .reloadTransactions(consumerList.list[index]);
              },
            );
          },
        ),
      ),
      floatingActionButton: _viewFAB
          ? FloatingActionButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      AddCustomersOverlay(customers: _customers)).then(
                  (value) =>
                      Provider.of<CustomerListModel>(context, listen: false)
                          .reloadCustomerList()),
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
                Provider.of<CustomerListModel>(context, listen: false)
                    .addCustomer(Customer(value!, 0));
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
      title: Text("Aktuelles Guthaben von ${widget.customer.name}"),
      content: Form(
        key: _balanceKey,
        child: Column(
          children: [
            // ToDo: Add texts
            TextFormField(
              onSaved: (String? value) {
                updateBalance(context,
                    Customer(widget.customer.name, double.parse(value!)));
                Navigator.of(context).pop();
              },
              validator: (String? value) {
                if (value?.isEmpty ?? false) {
                  return "Bitte eine Zahl eingeben";
                }
                if (!isNumeric(value!)) {
                  return "bitte eine Zahl eingeben";
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
