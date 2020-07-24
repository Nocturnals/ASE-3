import 'package:flutter/cupertino.dart';
import 'package:pet_app/petShop/model/data/cart.dart';
import 'package:pet_app/petShop/model/data/userData.dart';

class Order {
  List<Cart> orderItems;
  UserDataAddress address;
  UserDataCard cardDetails;
  DateTime orderDate;

  Order({
    @required this.orderItems,
    @required this.address,
    @required this.cardDetails,
    @required this.orderDate,
  });

  Order.fromMap(Map<String, dynamic> data) {
    address = UserDataAddress.fromMap(data['address']);
    cardDetails = UserDataCard.fromMap(data['cardDetails']);
    orderItems = List<Cart>();
    for (var i = 0; i < data['orderItems'].length; i++) {
      orderItems.add(Cart.fromMap(data['orderItems'][i]));
    }
    orderDate = data['orderDate'].toDate();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['address'] = address.toMap();
    map['cardDetails'] = cardDetails.toMap();
    List<Map<String, dynamic>> orders = List<Map<String, dynamic>>();
    for (var i = 0; i < orderItems.length; i++) {
      orders.add(orderItems[i].toMap());
    }
    map['orderItems'] = orders;
    map['orderDate'] = orderDate;

    return map;
  }
}
