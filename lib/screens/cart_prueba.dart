// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:practica4/common/theme.dart';
import 'package:practica4/models/cart.dart';
import 'package:practica4/models/catelog.dart';
import 'package:practica4/providers/cart_provider.dart';
import 'package:practica4/screens/cart_screen.dart';
import 'package:practica4/screens/catalog_screen.dart';
import 'package:provider/provider.dart';

class CartPrueba extends StatefulWidget {
  @override
  _CartPruebaState createState() => _CartPruebaState();
}

class _CartPruebaState extends State<CartPrueba> {
  final items = List<String>.generate(10, (i) => "Item ${i + 1}");

  @override
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => CatalogModel()),
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'flutter_cart',
        theme: appTheme,
        home: MyCatalog(),
        initialRoute: '/catalog',
        routes: {
          // '/': (context) => MyLogin(),
          '/catalog': (context) => MyCatalog(),
          '/cart': (context) => MyCart(),
        },
      ),
    );
  }
}
