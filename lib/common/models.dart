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
  final int id;
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
    this.resultingBalance, {
    this.id = 0,
  });

  // Convert Item into a Map, suitable for the Database.
  Map<String, dynamic> toMap() {
    //test
    return {
      "id": this.id,
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
