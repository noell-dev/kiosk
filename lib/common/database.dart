import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kiosk/common/models.dart';
import 'package:provider/provider.dart';

const DB_TABLES = [
  "CREATE TABLE customers(name TEXT PRIMARY KEY, balance DOUBLE)",
  "CREATE TABLE items(name TEXT PRIMARY KEY, price DOUBLE)",
  "CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, customerName TEXT, productName TEXT, quantity INTEGER, initalBalance DOUBLE, productPrice DOUBLE, resultingBalance DOUBLE)"
];

/// Define the common Database for persistent non key-value data
/// table overview:
/// 'habits' for type Habit
///
Future<Database> database() async {
  // Open the database and store the reference.
  return openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'kiosk.db'),
    onCreate: (db, version) {
      try {
        // run CREATE Table on Database for all Tables
        for (var table in DB_TABLES) {
          db.execute(table);
        }
      } catch (e) {
        return e;
      }
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

Future<List<Customer>> getCustomers() async {
  // get database reference
  final Database db = await database();

  // query for all marks for the selected year
  final List<Map<String, dynamic>> maps = await db.query(
    'customers',
  );
  // convert the List<Map<String, dynamic>> to a List<Marks>
  return List.generate(maps.length, (index) {
    return Customer(
      maps[index]["name"],
      maps[index]["balance"],
    );
  });
}

Future<List<Item>> getItems() async {
  // get database reference
  final Database db = await database();

  // query for all marks for the selected year
  final List<Map<String, dynamic>> maps = await db.query(
    'items',
  );
  // convert the List<Map<String, dynamic>> to a List<Marks>
  return List.generate(maps.length, (index) {
    return Item(
      maps[index]["name"],
      maps[index]["price"],
    );
  });
}

Future<List<Trans>> getTransactions(String customer) async {
  // get database reference
  final Database db = await database();

  // query for all marks for the selected year
  final List<Map<String, dynamic>> maps = await db
      .query('transactions', where: "customerName = ?", whereArgs: [customer]);
  // convert the List<Map<String, dynamic>> to a List<Marks>
  return List.generate(maps.length, (index) {
    return Trans(
      DateTime.parse(maps[index]["date"]),
      maps[index]["customerName"],
      maps[index]["productName"],
      maps[index]["quantity"],
      maps[index]["initalBalance"],
      maps[index]["productPrice"],
      maps[index]["resultingBalance"],
    );
  });
}

/// function to insert items into the database
Future<void> insertItem(String table, var item) async {
  // get database reference
  final Database db = await database();
  // insert into db
  // You might also specify the `conflictAlgorithm` to use in case the same item is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    table,
    item.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updateBalance(BuildContext context, Customer customer) async {
  final Database db = await database();
  double oldBalance;
  double difference;

  final List<Map<String, dynamic>> query = await db
      .query('customers', where: "name = ?", whereArgs: [customer.name]);
  if (query.isNotEmpty) {
    oldBalance = query[0]["balance"];
    difference = customer.balance - oldBalance;
    Provider.of<TransListModel>(context, listen: false).addTransaction(Trans(
      DateTime.now(),
      customer.name,
      "Ein/Auszahlung",
      1,
      oldBalance,
      difference,
      customer.balance,
    ));
    Provider.of<CustomerListModel>(context, listen: false)
        .updateCustomer(customer);
  }
}

Future<void> removeCustomer(String name) async {
  // get Database Reference
  final Database db = await database();

  // delete from DB
  db.delete("customers", where: "name = ?", whereArgs: [name]);
}

Future<void> removeItem(String name) async {
  // get Database Reference
  final Database db = await database();

  // delete from DB
  db.delete("customers", where: "name = ?", whereArgs: [name]);
}

Future<void> removeTrans(int id) async {
  // get Database Reference
  final Database db = await database();

  // delete from DB
  db.delete("transactions", where: "id = ? ", whereArgs: [id]);
}
