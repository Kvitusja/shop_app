import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/product_overview.dart';
import 'screens/splash_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/authentification_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previousProducts) => Products(
            auth.token ?? '',
            previousProducts?.items ?? [],
            auth.userId,
          ),
          create: (context) => Products('', [], ''),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Cart(),
        ),
        // ChangeNotifierProvider(
        //   create: (BuildContext context) => Orders(),
        // ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previousOrders) => Orders(
            previousOrders?.orders ?? [],
            auth.token ?? '',
            auth.userId!,
          ),
          create: (context) => Orders([], '', ''),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authentication, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              //scaffoldBackgroundColor: Colors.brown,
              scaffoldBackgroundColor: Colors.white70,
              iconTheme: const IconThemeData(
                color: Color(0xff24788F),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(190, 232, 255, 1),
                primaryContainer: const Color.fromRGBO(190, 232, 255, 1),
              ),
            ),
            home: authentication.isAuthenticated
                ? const ProductOverviewScreen()
                : FutureBuilder(
                    future: authentication.tryAutoLogin(),
                    builder: (BuildContext context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthenticationScreen()),
            routes: {
              ProductDetailsScreen.routeName: (ctx) =>
                  const ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
              AuthenticationScreen.routeName: (ctx) =>
                  const AuthenticationScreen(),
            }),
      ),
    );
  }
}
