import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  // InputData: data can be changed externally by the constructor.
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text(
                      'ORDER NOW',
                    ),
                    onPressed: () {
                      Provider.of<Orders>(context).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      cart.clear();
                    },
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, i) => CartItem(
              cart.items.values.toList()[i].id,
              cart.items.keys.toList()[i],
              cart.items.values.toList()[i].title,
              cart.items.values.toList()[i].price,
              cart.items.values.toList()[i].quantity,
            ),
          ),
        ],
      ),
    );
  }
}

// List_CartItems: ListView.builder(itemCount:cart.items.length,
// we could use Provider.class with ChangeNotifier but don't really need it
// itemBuilder: (ctx, i) => CartIteme(pa:id, title,price,quantity
// cart.items[i].id, cart.items[i].title, cart.items[i].price, cart.items[i].quantity))
// come from map:  wanna work for concrete values store in a map turn to a list.values.toList()
// we are insterested of the keys of the Cart: cart.keys.toList()[i];
//  toDismissedCartItems..we..need..forward..ProductId_of_the_Cart[keys]:
//  we rebuild CartScreen when our list changes: Provider.of<Cart>(context); and not the cartItem
//
//
// as we have twice CarItem [1.from Provider 2. form CartItem Widgets]
// use: prefix: import '...' as ci;  => ci.CartItem()  //for the Widgets
// use: show only require element: import '...' show Cart; //show only CartItem
//
// error: No such error: The getter id was called on null
// come from map:  wanna work for concrete values store in a map turn to a list.values.toList()
// cart.items.values.toList()[i].id
//
// adding ORders CartScreen:
// Provider.of<Orders>(context, listen:false).addOrders(
//  cart.items.values.toList(), cart.totalAmount);
//  important to clear items in the Cart_Providers not in the Orders_Provider

// chip: Widget with roundedCorner display information
// display: total_price in the Cart
// label: Text('\$${cart.totalAmout}', style:
// TextStyle(color: Theme....primaryTextTheme.headline6.color)),
// Spacer()
// FlatButton(child:Text(), textColor: Theme...primaryColor)
