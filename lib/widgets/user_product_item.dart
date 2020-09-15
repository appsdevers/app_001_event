import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

// get information from outSide:

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  // InputData: data can be changed externally by the constructor.
  @override
  Widget build(BuildContext context) {
    // build reRendersUI of the apps. Don't use properties and methods here cause will be reset by the app! [appBarSize_use] [isLandscape_use]
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                // only use this to refresh
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
            )
          ],
        ),
      ),
    );
  }
}

// fixed sizing: Row: Container(width: 100),

// image_provider:
// backgroundImage: ImageProvider:
// NetworkImage('url')  || AssetImage(') => JUST OBJECT FETCH IMAGE
