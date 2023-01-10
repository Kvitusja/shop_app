import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/app_drawer.dart';
import '../Widgets/user_product_item.dart';
import '../providers/products.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/user_products_screen';

  Future<void> _refreshProducts(BuildContext context) async{
   await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh:() => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.separated(
              separatorBuilder: (_, int index) => const Divider(
                    height: 1,
                  ),
              itemCount: productsData.items.length,
              itemBuilder: (_, int index) {
                return UserProductItem(
                  title: productsData.items[index].title,
                  imageUrl: productsData.items[index].imageUrl,
                  id: productsData.items[index].id!,
                );
              }),
        ),
      ),
    );
  }
}
