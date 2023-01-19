import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

import '../screens/authentification_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

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
          const Divider(),
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
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            title: const Text(
              'Manage Products',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('LogOut'),
                    content: const Text('Do you want to logout?'),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(AuthenticationScreen.routeName);
                          Provider.of<Auth>(context, listen: false).logout();
                          //Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                );
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(1),
                backgroundColor: MaterialStateProperty.all<Color?>(
                    Theme.of(context).colorScheme.secondary),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
