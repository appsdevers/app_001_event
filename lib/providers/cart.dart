import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title; //tile of the Product
  final int quantity; //how many items of the Products
  final double price; //calculate totalPrice = price*quantity

// fprod_cart_orders_auth

  // fcartitem
  // Cart: [matches==Products] {id_cart}, {cart_title:product_title}, {cart_quantity+product_quantity}, {cart_price:product_price}
  // fcart
  // fcart_Icount
  // fcart_totalA
  // fcart_addI
  // fcart_rmEntry_items
  // fcart_rmEntry_item
  // fcart_clear

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

// map every cartItem to the id of the Product it belongs To
class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  // count item
  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

// adding Item: get ProductId, price, title

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

// remove an Entry from a Cart: pass key. productId
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // remove singleItem after click CartIcon in the ProductOverviewScreen
  // 3 conditions: 1-If we don't have an entry for this product on this Cart
  //  2-If _items for the given productId is > 1, then update.items
  //  3-Else productId(0) productId(>1) productId(1)

  void removeSingleItem(String productId) {
    // if productId ISNOT part of the Cart we return nothing
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          price: existingCartItem.price,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else
      _items.remove(productId);
    notifyListeners();
  }

  // place an order then we remove cartItem
  void clear() {
    _items = {};
    notifyListeners();
  }
}

// go throught all elements in my Card:
// var total = 0.0;
//  _items.forEach((key, cartItem) {
// take my existing total_value and add:  price*quantity
// total += cartItem.price  * cartItem.quantity;
// }) return total;

// mapItem where the key is Product. Map<String,CartItem> _items = {};
// cartItem(id_Cart, title_Product, price_Product, quantity_Product);
// countEntry_In_a_Map_Cart:
// countItem(int get itemCount => _items.length;)
// totalItem()
// addEntry_To_a_Map_Cart:
// addItem(title,price,quantity){if(_items.update(..., (value)=> ...)){}
// else{_items.putIfAbsent(..., ....)} notifyListeners();}
// removeEntry_From_a_Map_Cart:
// removeItem(String productId) {_items.remove(productId); notifyListeners();}
// : total was update.  when go to new page and return back it's still gone
// : totalAmount_was_update. we update_Visually_and__in_our_data

// map an Item where the Key is the ProductId
// now add_Item
// check if we have cartItem entry in the Cart
// if _items.containsKey(productId): yes: we only need to update the quantity
// _items.update(productId, (existingCartItem) => CartItem(id: existingCartItem.id,
// title: existingCartItem.title, price: existingCartItem.price,
// quantity: existingCartItem.quantity +1),),
// else: we need to add a new entry:
// _items.putIfAbsent(productId, () => CartItem(id: DateTime.now(), title:, price:, quantity:1))

// define couple of cartItem: can define into separate file define it into same files
