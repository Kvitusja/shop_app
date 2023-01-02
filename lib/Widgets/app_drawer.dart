import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'Hello Friend!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.shop,
              color: Colors.white,
            ),
            title: const Text(
              'Shop',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          ListTile(
            leading: const Icon(
              Icons.payment,
              color: Colors.white,
            ),
            title: const Text(
              'Orders',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
        ],
      ),
    );
  }
}
