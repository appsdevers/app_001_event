import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  // internal state: can't be recreated it's persistant it's attached to the class. The external data can be recreated but the state NO!
  @override
  Widget build(BuildContext context) {
    // build reRendersUI of the apps. Don't use properties and methods here cause will be reset by the app! [appBarSize_use] [isLandscape_use]
    print('OrderItem rebuilds');
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$order'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          // add Container which heigth depend of the amount of the amount
          // of item we have on the list
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView(
                  children: widget.order.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${prod.quantity}x \$${prod.price}',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ))
                      .toList()),
            ),
        ],
      ),
    );
  }
}

// here_I_EXPECT TO GET THAT DATA FROM OUTSIDE[PROVIDER]:
// with ITEMS__GET_DATA__[`FROM_INSIDE__OR__OUTSIDE`_PROVIDER]
// NOT IMPORT:
//  [PROVIDER_PACKAGE] only IMPORT 'providers/class[orders]'
// import './providers/orders' as ord;
// final ord.OrderItem order
// DateFormat('dd/MM yyyy hh:mm').format(order.date),

// build an EXPANDABLE CARD: fcol
// Column([1.element])
//
// CHANGE WETHER THE ICON IS DISPLAY OR NOT:
// affects only this widgets: STFULL
// var _expand = false;
//IconButton_icon should change when it's expanded or not
// IconBUtton(icon: _expand ? fic.expand.less : fic.expand.more
// expand_more{ setState(){( _expand = !expand;)} })
//  Below __ListTile__add__
// if(_expanded): add a Container with a height depending
//    on the amount of the child in the list
//
// dart:math; give us a min height of 2 values function we can use
// if(_expanded) Container(height: min())
// I want to get the AmountOfProducts * 20.0 + 100,
// and get a based height of:  180
//
