import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:kiosk/common/database.dart';

class Item {
  final String name;
  final double price;

  Item(
    this.name,
    this.price,
  );

  // Convert Item into a Map, suitable for the Database.
  Map<String, dynamic> toMap() {
    //test
    return {
      "name": this.name,
      "price": this.price,
    };
  }
}

class Customer {
  final String name;
  final double balance;

  Customer(
    this.name,
    this.balance,
  );

  // Convert Item into a Map, suitable for the Database.
  Map<String, dynamic> toMap() {
    //test
    return {
      "name": this.name,
      "balance": this.balance,
    };
  }
}

class Trans {
  final DateTime date;
  final String customerName;
  final String productName;
  final int quantitiy;
  final double initalBalance;
  final double productPrice;
  final double resultingBalance;

  Trans(
    this.date,
    this.customerName,
    this.productName,
    this.quantitiy,
    this.initalBalance,
    this.productPrice,
    this.resultingBalance,
  );

  // Convert Item into a Map, suitable for the Database.
  Map<String, dynamic> toMap() {
    //test
    return {
      "date": this.date.toIso8601String(),
      "customerName": this.customerName,
      "productName": this.productName,
      "quantity": this.quantitiy,
      "initalBalance": this.initalBalance,
      "productPrice": this.productPrice,
      "resultingBalance": this.resultingBalance,
    };
  }
}

class TransListModel extends ChangeNotifier {
  final List<Trans> _transactions = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Trans> get list => UnmodifiableListView(_transactions);

  void reloadTransactions(Customer customer) async {
    final List<Trans> _temp = await getTransactions(customer.name);
    _transactions.clear();
    _transactions.addAll(_temp);
    notifyListeners();
  }

  void addTransaction(Trans transaction) {
    _transactions.add(transaction);
    insertItem("transactions", transaction);
    notifyListeners();
  }
}

class CustomerListModel extends ChangeNotifier {
  final List<Customer> _customers = [];
  Customer _currentCustomer = new Customer("_null_", 0);

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Customer> get list => UnmodifiableListView(_customers);

  Customer get cc => _currentCustomer;

  void updateCC(Customer _newCustomer) {
    _currentCustomer = _newCustomer;
    notifyListeners();
  }

  void reloadCustomerList() async {
    final List<Customer> _temp = await getCustomers();
    _customers.clear();
    _customers.addAll(_temp);
    notifyListeners();
  }

  void addCustomer(Customer customer) {
    _customers.add(customer);
    insertItem("customers", customer);
    notifyListeners();
  }

  void updateCustomer(Customer customer) {
    _currentCustomer = customer;
    insertItem("customers", customer);
    reloadCustomerList();
  }
}
