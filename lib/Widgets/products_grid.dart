import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavourites;
  const ProductsGrid({
    Key? key,
    required this.showOnlyFavourites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    final products =
        showOnlyFavourites ? productsData.favouriteItems : productsData.items;
    return FutureBuilder(
        future: Provider.of<Products>(context).fetchAndSetProducts(),
        builder: (context, AsyncSnapshot dataSnapshot) {
          // if (!dataSnapshot.hasData) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: const ProductItem(),
            ),
          );
        });
  }
}
