// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:practica4/models/cart_model.dart';
import 'package:practica4/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.headline1),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        color: const Color.fromRGBO(40, 38, 56, 1),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _CartList(),
              ),
            ),
            const Divider(height: 4, color: Colors.pink),
            _CartTotal()
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.headline6;

    var cartProvider = context.watch<CartProvider>();

    return ListView.builder(
      itemCount: cartProvider.flutterCart.cartItem.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              cartProvider.decrementItemFromCartProvider(index);
              Scaffold.of(context).showSnackBar(
                const SnackBar(
                  content: Text('1 item removed from cart'),
                ),
              );
            } else {
              cartProvider.deleteItemFromCart(index);
              Scaffold.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All items removed from cart'),
                ),
              );
            }
          },
          background: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              color: Colors.black,
              child: Text(
                'Delete All',
                style: itemNameStyle,
              )),
          secondaryBackground: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: Text(
                'Delete One',
                style: itemNameStyle,
              )),
          child: ListTile(
            leading: Text(
                '${cartProvider.flutterCart.cartItem[index].quantity}',
                style: itemNameStyle),
            title: Text(
              cartProvider.flutterCart.cartItem[index].productName.toString(),
              style: itemNameStyle,
            ),
            subtitle: Text(
                '\$${cartProvider.flutterCart.cartItem[index].unitPrice}',
                style: TextStyle(color: Colors.white)),
            trailing: IconButton(
              icon: Icon(Icons.add_box_rounded, color: Colors.pink),
              onPressed: () {
                cartProvider.incrementItemToCartProvider(index);
              },
            ),
          ),
        );
      },
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle =
        Theme.of(context).textTheme.headline1!.copyWith(fontSize: 48);

    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CartProvider>(
                builder: (context, cart, child) => Text(
                    '\$${cart.getTotalAmount().toString()}',
                    style: hugeStyle)),
            const SizedBox(width: 24),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buying not supported yet.')));
              },
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.pink),
              child: const Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
