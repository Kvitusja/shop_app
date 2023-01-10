import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_products_screen';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: 'title',
    description: 'description',
    price: 0,
    imageUrl: 'imageUrl',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg')) {
        return;
      }
      setState(() {
        //_imageUrlController;
      });
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
    // Navigator.of(context).pop();
  }


  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    buildTextFormField(
                      context,
                      TextInputAction.next,
                      (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      FocusNode(),
                      'Product title',
                      TextInputType.text,
                      (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                      (value) {
                        if (value!.isEmpty) {
                          return 'Write down a correct title';
                        }
                        if (int.tryParse(value) != null) {
                          //print('title is int');
                          return 'Write down a correct value';
                        }
                        return null;
                      },
                      _initValues['title'],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildTextFormField(
                      context,
                      TextInputAction.next,
                      (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      _priceFocusNode,
                      'Product price',
                      TextInputType.number,
                      (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value!),
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                      (value) {
                        if (value!.isEmpty) {
                          return 'Write down a correct value';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please write a value in numbers';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Write down a number which is greater than zero';
                        }
                        return null;
                      },
                      _initValues['price'],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildTextFormField(
                      context,
                      TextInputAction.next,
                      (_) {},
                      _descriptionFocusNode,
                      'Description',
                      TextInputType.multiline,
                      (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                      (value) {
                        if (value!.isEmpty) {
                          return 'Write down a correct value';
                        }
                        if (value.runtimeType != String) {
                          return 'Write down a correct value';
                        }
                        if (value.length < 10) {
                          return 'Description should be at least 10 characters';
                        }
                        return null;
                      },
                      _initValues['description'],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image Url',
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'No image link provided!';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid URL';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value!,
                                isFavourite: _editedProduct.isFavourite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  buildTextFormField(
    BuildContext context,
    TextInputAction textInputAction,
    void Function(String) onFiledSubmitted,
    FocusNode focusNode,
    String labelText,
    TextInputType keyboardType,
    void Function(String?) onSaved,
    String? Function(String?) validator,
    String? initialValue,
  ) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      textInputAction: textInputAction,
      onFieldSubmitted: onFiledSubmitted,
      focusNode: focusNode,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
    );
  }
}

// textInputAction: TextInputAction.next,
// onFieldSubmitted: (_) {
// FocusScope.of(context).requestFocus(_priceFocusNode);
