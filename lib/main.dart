import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop',
        theme: ThemeData(
          primaryColor: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}

// [ADDING SPLASH SCREENS]:                           =>  flutter launch icons
// flutter_launch_icons: 0.7.2                        =>  Launch for all kinds of devices
// dev_dependencies:                                  =>  dependencies need during development not during final app
//   flutter_test:
//     sdk: flutter
//   flutter_launcher_icons: ^0.7.2
//
// flutter_icons:
//   android: true
//   ios: true
//   image_path: 'dev_assets/places.png'<double_quote>
//   adaptative_icon_background: '#191919'<double_quote>
//   adaptative_icon_foreground: 'dev_assets/places_adaptive.png'<double_quote>
//
//terminal> flutter pub run flutter_launch_icons:main
