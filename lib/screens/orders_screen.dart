import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../Widgets/app_drawer.dart';
import '../Widgets/order_widget.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const routeName = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your order'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (BuildContext context, index) {
          return OrderWidget(currentOrder: orderData.orders[index]);
        },
      ),
    );
  }
}
