import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.id, this.productId, this.title, this.price, this.quantity);

  // InputData: data can be changed externally by the constructor.
  @override
  Widget build(BuildContext context) {
    // build reRendersUI of the apps. Don't use properties and methods here cause will be reset by the app! [appBarSize_use] [isLandscape_use]
    print('CartItem rebuilds');
    // fdismiss

    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        // confirmDismiss: (direction) => Future.value(true); notIdea
        // showDialog return a Future. match with confirmDismiss
        // Navigator.of(ctx).pop(false/true);

        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: ${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}

// AlertDialogs:
//

// we need: Cart:id, ProductId:productId, Cart:title, Cart:price, Cart:quantity,
//
// Dismissible: ValueKey(keyItem: id),
// background:(Show when dismisses Item) Container(color: Theme.of(context).errorColor,)
// showWhatHappen when dismiss: Container(color...,
//  child:fic(delete), pd.Right(20), alignment.RigthCenter, margin: same.of.Card)
// dismiss_direction: direction: DismissDirection.endToStart [Right to Left]
// what happens when we dismiss visually:
//  onDismissed: (direction) {
// Provider.of(context, listen:false).removeItem(productId);}
// : total was update.  when go to new page and return back it's still gone
// : totalAmount_was_update. we update_Visually_and__in_our_data
//  don't wanna to listen to changes

// => Card()

// CartScreen = ListItems.. use ListView.builder(itemCount: cart.items.length)
// pa: received: id, title, price, quantity
// cartItem = leading:price, title:title, subtitle:price*quantity, trailing: quantity x
