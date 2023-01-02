import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_details_screen.dart';


class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  const ProductItem(
      {Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridTile(
        footer: GridTileBar(
          leading: IconButton(
            onPressed: product.toggleFavouriteStatus,
            icon: Icon(
              product.isFavourite ? Icons.favorite : Icons.favorite_outline,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87),
          ),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
