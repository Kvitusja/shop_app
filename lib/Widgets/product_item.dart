import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ColoredBox(
        color: Colors.white70,
        child: GridTile(
          footer: GridTileBar(
            leading: IconButton(
              onPressed: () {
                product.toggleFavouriteStatus(authData.token, authData.userId!);
              },
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_outline,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(
                    product.id as String, product.price, product.title);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Add an item to the cart'),
                    duration: const Duration(seconds: 6),
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cart.removeSingleItem(product.id as String);
                        }),
                  ),
                );
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
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90.0),
                child: Hero(
                  tag: product.id as Object,
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/product-preload.png'),
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // child: CircleAvatar(
              //   backgroundImage:
              //   NetworkImage(
              //     product.imageUrl,
              //   ),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
