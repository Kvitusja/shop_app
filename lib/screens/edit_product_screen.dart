import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_products_screen';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
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
              ),
              const SizedBox(
                height: 10,
              ),
              buildTextFormField(
                context,
                TextInputAction.next,
                (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                _priceFocusNode,
                'Product price',
                TextInputType.number,
              ),
              const SizedBox(
                height: 10,
              ),
              buildTextFormField(
                context,
                TextInputAction.send,
                (_) {},
                _descriptionFocusNode,
                'Description',
                TextInputType.multiline,
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
      TextInputType keyboardType) {
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
        keyboardType: keyboardType);
  }
}

// textInputAction: TextInputAction.next,
// onFieldSubmitted: (_) {
// FocusScope.of(context).requestFocus(_priceFocusNode);
