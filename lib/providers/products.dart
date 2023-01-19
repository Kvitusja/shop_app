import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String? authToken;
  final String? userId;

  Products(
    this.authToken,
    this._items,
    this.userId,
  );

  List<Product> get items {
    return [..._items];
  }

  Product findById(String? id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get favouriteItems {
    return _items.where((productItem) => productItem.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts(bool filterByUser) async {
    var params = {
      'auth': authToken,
    };
    if (filterByUser) {
      params = {
        'auth': authToken,
        'orderBy': '"creatorId"',
        'equalTo': '"$userId"',
      };
    }
    final url = Uri.https(
      'shoptestapp-cc209-default-rtdb.europe-west1.firebasedatabase.app',
      '/products.json', params
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      final favouriteUrl = Uri.https(
          'shoptestapp-cc209-default-rtdb.europe-west1.firebasedatabase.app',
          '/userFavourites/$userId.json',
          {'auth': authToken});
      final favouriteResponse = await http.get(favouriteUrl);
      final favouriteData = jsonDecode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavourite: favouriteData == null
                ? false
                : favouriteData[productId] ?? false,
          ),
        );
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    var params = {'auth': authToken};
    final url = Uri.https(
        'shoptestapp-cc209-default-rtdb.europe-west1.firebasedatabase.app',
        '/products.json',
        params);
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    var params = {'auth': authToken};
    final url = Uri.https(
        'shoptestapp-cc209-default-rtdb.europe-west1.firebasedatabase.app',
        '/products/$id.json',
        params);
    await http.patch(url,
        body: jsonEncode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }));
    _items[productIndex] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    var params = {'auth': authToken};
    final url = Uri.https(
        'shoptestapp-cc209-default-rtdb.europe-west1.firebasedatabase.app',
        '/products/$id.json',
        params);
    _items.removeWhere((prod) => prod.id == id);
    http.delete(url);
    notifyListeners();
  }

}
