import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart' show Product;
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String image;

  // ProductItem({this.id, this.title, this.image});

  // InputData: data can be changed externally by the constructor.
  @override
  Widget build(BuildContext context) {
    // build reRendersUI of the apps. Don't use properties and methods here cause will be reset by the app! [appBarSize_use] [isLandscape_use]
    print('reBuild ProductItem');

    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.asset(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);

              // timeout SnackBar come out after you show current SnackBar
              // so to hide previous SnackBar and show current press

              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added Item to the Cart!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

// snackBar:
// timeout SnackBar come out after you show current SnackBar
// so to hide previous SnackBar and show current press
// Scaffold.of(context).hideCurrentSnackBar();
// Scaffold.of(context).showSnackBar(SnackBar(content: Text(''),
// duration: Duration(secods:2,) action:SnackBarAction(label: 'UNDO',)
// onPressed: () {cart.removeSingleItem(product.id)};

// addItemToCart connectingCartProvider:
// ProductItem: IconButton(shopping_cart), onPressed.Shopping_cart
// provide. cartContainer and addBy calling: cart.addItem(...,...,...);

// Consumer_use:
// Consumer<Product>(
// builder: (ctx,<nearest_Instance_it_found_of_that_Data:_product_>,
// child:ch:_)) => WidgetTree, child: Widget||Text('Never changes!'),

// GridView.builder_use:
// GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// childAspectRatio: 3 / 2, crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 2,),))

// GridTile_use:
// ClipRRect(borRad10) => GridTile(ch: GestureDec{forward id_to_ProductDetailScreen} Image.network(imageUrl), ) + GridTileBar
// footer: GridTileBar(backgroundColor: , leading: IconBut(favorite), title: , trailing: IconBut(shopping_cart))
