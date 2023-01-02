import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/app_drawer.dart';
import '../Widgets/cart_item.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import 'orders_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      label: Text(
                        '${cart.totalAmount}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount,
                        );
                        Navigator.of(context).pushNamed(OrdersScreen.routeName);
                        cart.clearCart();
                      },
                      child: Text(
                        'Order Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (BuildContext context, index) {
                return CartItemTile(
                  id: cart.items.values.toList()[index].cartItemId,
                  price: cart.items.values.toList()[index].pricePerProduct,
                  quantity: cart.items.values.toList()[index].quantity,
                  title: cart.items.values.toList()[index].productTitle,
                  productId: cart.items.keys.toList()[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
