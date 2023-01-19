import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatefulWidget {
  final bool showOnlyFavourites;
  const ProductsGrid({
    Key? key,
    required this.showOnlyFavourites,
  }) : super(key: key);

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  late Future<void> fetchedData;

  @override
  void initState() {
    fetchedData =
        Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = widget.showOnlyFavourites
        ? productsData.favouriteItems
        : productsData.items;
    return FutureBuilder(
      future: fetchedData,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
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
        }
      },
    );
  }
}
