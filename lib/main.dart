import 'package:flutter/material.dart';
import 'package:kiosk/panels/Customers.dart';
import 'package:kiosk/panels/Items.dart';
import 'package:kiosk/panels/Transactions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiosk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Kiosk Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double _middleBorder = 2;
    Size _size = MediaQuery.of(context).size;
    double _height = _size.height - 80;
    double _width = _size.width - _middleBorder;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(color: Colors.blue, width: _middleBorder)),
            ),
            child: Column(
              children: [
                Container(
                  height: _height,
                  width: _width / 2,
                  child: ItemsPanel(),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: _height / 2,
                width: _width / 2,
                child: CustomersPanel(),
              ),
              Container(
                height: _height / 2,
                width: _width / 2,
                child: TransactionsPanel(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
