import 'package:flutter/material.dart';
import 'package:practica4/models/cart_model.dart';
import 'package:practica4/models/catelog.dart';
import 'package:practica4/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class MyCatalog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(40, 38, 56, 1),
      body: CustomScrollView(
        slivers: [
          _MyAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _MyListItem(index)),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  final Item item;

  const _AddButton({required this.item, Key? key}) : super(key: key);

  @override
  __AddButtonState createState() => __AddButtonState();
}

class __AddButtonState extends State<_AddButton> {
  late CartProvider _cartProvider;
  late CartItem? _cartItem;
  late int _isInCart;
  late int _itemCount;

  @override
  void initState() {
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    super.initState();
  }

  int _checkItemisInCart() {
    _cartItem = _cartProvider.getSpecificItemFromCartProvider(widget.item.id);
    return _cartItem?.quantity ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    _isInCart = _checkItemisInCart();

    return TextButton(
      onPressed: _isInCart != 0
          ? null
          : () {
              _cartProvider.addToCart(widget.item);
              setState(() {});
            },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: _isInCart != 0
          ? const Icon(
              Icons.check,
              semanticLabel: 'ADDED',
              color: Colors.green,
            )
          : const Icon(Icons.add, semanticLabel: 'ADD'),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title:
          Text('Colors Catalog', style: Theme.of(context).textTheme.headline1),
      floating: true,
      automaticallyImplyLeading: false,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => Navigator.pushNamed(context, '/cart'),
            ),
            Consumer<CartProvider>(
              builder: (context, consumer, child) {
                return Positioned(
                  right: 10,
                  child: Text("${consumer.getCartItems().length}"),
                );
              },
            )
          ],
        ),
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
      ],
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;

  const _MyListItem(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var item = context.select<CatalogModel, Item>(
      (catalog) => catalog.getByPosition(index),
    );
    var textTheme = Theme.of(context).textTheme.headline6;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.primaries[index % Colors.primaries.length],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(item.name, style: textTheme),
            ),
            const SizedBox(width: 24),
            Consumer<CartProvider>(builder: (context, cart, child) {
              return _AddButton(item: item);
            }),
          ],
        ),
      ),
    );
  }
}
