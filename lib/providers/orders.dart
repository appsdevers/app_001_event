import 'package:flutter/material.dart';

import './cart.dart';

// define how orders should look like
class OrderItem {
  final String id;
  final double amount; //totalAmount_Ordered
  final List<CartItem> products; // find which products are ordered
  final DateTime date; //date it's has been ordered

  // OrderItem: [matches==Cart] {id_order}, {amount:product_totalAmount}, {products:List<CartItem>}, {date==date it's has been ordered}

  // fcartitem
  // fcart
  // fcart_Icount
  // fcart_totalA
  // fcart_addI
  // fcart_rmEntry
  // fcart_rmItems
  // fcart_clear

  

  // forditem
  // ford
  // fadd_ord  fclear_cart

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.date,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  // add order which executes when we click on a Button:
  // add all the content of the Cart into the Order
  // list of CartItems, total
  // _orders.insert(0, element): move new_orders to the Top of
  //   the List and move others orders an index Ahead
  // ..element: OrderItem(id: DateTime.now().toString(),
  //  amount:total, date: DateTime.now(), products:cartProducts,)
  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          date: DateTime.now(),
          products: cartProducts),
    );
    notifyListeners();
  }
}

// add order which executes when we click on a Button:
// add all the content of the Cart into the Order
// list of CartItems, total
// _orders.insert(0, element): move new_orders to the Top of
//   the List and move others orders an index Ahead
// ..element: OrderItem(id: DateTime.now().toString(),
//  amount:total, date: DateTime.now(), products:cartProducts,)

// place an order then we remove cartItem
// where_Provide__Orders(): need_in__CartScreen__OrderScreen:
// provide__ABOVE_those_Screens: root_App
