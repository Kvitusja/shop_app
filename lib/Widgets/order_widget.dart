import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart';

class OrderWidget extends StatefulWidget {
  final OrderItem currentOrder;

  const OrderWidget({Key? key, required this.currentOrder}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? min(widget.currentOrder.products.length * 20 + 135, 220) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.currentOrder.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh: mm')
                    .format(widget.currentOrder.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            //if (_expanded)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _expanded ? min(widget.currentOrder.products.length * 20 + 40, 180) : 0,
                child: ListView(
                  children: widget.currentOrder.products
                      .map((product) => Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(width: 20,),
                              Text(
                                product.productTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  //color: Colors.white
                                ),
                              ),
                              Text(
                                '${product.quantity} x \$${product.pricePerProduct}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  //color: Colors.white,
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
