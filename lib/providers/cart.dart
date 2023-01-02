import 'package:flutter/material.dart';

class CartItem {
  final String cartItemId;
  final String productTitle;
  final int quantity;
  final double pricePerProduct;

  CartItem(
      {required this.cartItemId,
      required this.productTitle,
      required this.quantity,
      required this.pricePerProduct});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.values
        .fold(0, (quantity, cartItem) => cartItem.quantity + quantity);
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.pricePerProduct * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                cartItemId: existingCartItem.cartItemId,
                productTitle: existingCartItem.productTitle,
                quantity: existingCartItem.quantity + 1,
                pricePerProduct: existingCartItem.pricePerProduct,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          cartItemId: DateTime.now.toString(),
          productTitle: title,
          quantity: 1,
          pricePerProduct: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            cartItemId: existingCartItem.cartItemId,
            productTitle: existingCartItem.productTitle,
            quantity: existingCartItem.quantity - 1,
            pricePerProduct: existingCartItem.pricePerProduct),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
