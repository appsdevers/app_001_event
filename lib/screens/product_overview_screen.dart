import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  // InputData: data can be changed externally by the constructor.

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;

  // internal state: can't be recreated it's persistant it's attached to the class. The external data can be recreated but the state NO!

  @override
  Widget build(BuildContext context) {
    // build reRendersUI of the apps. Don't use properties and methods here cause will be reset by the app! [appBarSize_use] [isLandscape_use]
    print('reBuild ProductOverviewScreen');
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favorites) {
                _showOnlyFavorites = true;
              } else {
                _showOnlyFavorites = false;
              }

              print(selectedValue);
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}

//  addItemToCart connectingCartProvider:
// ProductItem: IconButton(shopping_cart), onPressed.Shopping_cart
// provide. cartContainer and addBy calling: cart.addItem(...,...,...);

// output cartItemCount. Result...[PopupMenuButton(),
// Consumer<Cart>(builder:(_,cart,ch) => Badge(child:ch,
//  value: cart.itemCount.toString(), ), child: fic )]

// outside of the class: enum FilterOptions {Favorites, All}: assigning labels to integers
// PopupMenuButton( icon:, itemBuilder:(ctx, _{don't need it})
//   onSelected: (int selectedValue) {
//  if(selectedValue == FilterOptions.Favorites){
//      //... }
//  else {//}
//    print(selectedValue)},
//   => list_Widgets.add.as.entries[
// PopupMenuItem(child: Text('Only Favorites'), value: 0,),
// PopupMenuItem(child: Text('Show All'), value: 1,),
// ]
//
// APP WIDE FILTER
// now in our Products provider class we do:
// var _showFavoritesOnly = false;
// List<Product> get _items {if(_showFavoritesOnly() {
//  return _items.where((prodItem) => prodItem.isFavorite);   }  )}
// void showFavoritesOnly () {_showFavoritesOnly = true; }
// void showAll () {_showFavoritesOnly = false; }
// if it's favorite call new method in Products Provider
// call objects productContainer.showFavorites(), // productContainer.showAll()
//
//  HAS A FLAW:
// If we have a screen which used productsContainer then filter
// will be apply caused our products getter  [_items Products]
// only return data based only on _showFavoritesOnly__filter
// APPLICATION WIDE FILTER
// OFTEN APPLY FILTER ON ONE SCREEN: MANAGE_PRODUCT & VIEW_PRODUCT
// :filtering on ALL ProductsScreen NOT ON MyProductScreen
//
//  YOU SHOULD MANAGE FILTERING LOGIC AND SIMILAR KIND OF THINGS
// OF COURSE) [IN A WIDGET] TYPICALLY. [NOT GLOBALLY!]
//
// APP LOCAL FILTER:  STATEFULL_WIDGET
// Products Provider _build_new_list_of getter_Favorites: favoriteItems()
// ... return _items.where((prodItem) => prodItem.isFavorite);
// Affects: ProductOverviewScreen & ProductGrid
// var _showOnlyFavorites = false;
// onSelected(... ... ) { setState(){( if(...){_showOnlyFavorites = true;}
// else {_showOnlyFavorites = false;} )} }
// forward => _showOnlyFavorites = false;
//    ProductsGrid(_showFavorites);
//    In ProductsGrid__render..
// products =_showFavs ? productsData.favoriteItems : productsData.items;
