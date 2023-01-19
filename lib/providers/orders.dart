import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(
    this._orders,
    this.authToken,
    this.userId,
  );

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var params = {
      'auth': authToken,
    };
    final url = Uri.https(
        'shoptestapp-cc209-default-rtdb.europe-west1.firebasedatabase.app',
        '/orders/$userId.json',
        params);
    final timeStamp = DateTime.now();
    final orderResponse = await http.post(
      url,
      body: jsonEncode({
        'amount': total,
        'products': cartProducts
            .map((cartProduct) => {
                  'id': cartProduct.cartItemId,
                  'title': cartProduct.productTitle,
                  'price': cartProduct.pricePerProduct,
                  'quantity': cartProduct.quantity,
                })
            .toList(),
        'dateTime': timeStamp.toIso8601String(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: jsonDecode(orderResponse.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    var params = {'auth': authToken};
    final url = Uri.https(
        'shoptestapp-cc209-default-rtdb.europe-west1.firebasedatabase.app',
        '/orders/$userId.json',
        params);
    final ordersResponse = await http.get(url);
    //print(jsonDecode(ordersResponse.body));
    final List<OrderItem> loadOrders = [];
    final extractedData =
        jsonDecode(ordersResponse.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        products: (orderData['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                  cartItemId: item['id'],
                  productTitle: item['title'],
                  quantity: item['quantity'],
                  pricePerProduct: item['price']),
            )
            .toList(),
        dateTime: DateTime.parse(orderData['dateTime']),
      ));
    });
    _orders = loadOrders.reversed.toList();
    notifyListeners();
  }
}
