// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final items = List<String>.generate(10, (i) => "Item ${i + 1}");

  @override
  Widget build(BuildContext context) {
    final title = 'Cart';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(40, 38, 56, 1),
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Dismissible(
              // Cada Dismissible debe contener una llave. Las llaves permiten a Flutter
              // identificar de manera única los Widgets.
              key: Key(item),
              // También debemos proporcionar una función que diga a nuestra aplicación
              // qué hacer después de que un elemento ha sido eliminado.
              onDismissed: (direction) {
                // Remueve el elemento de nuestro data source.
                setState(() {
                  items.removeAt(index);
                });

                // Luego muestra un snackbar!
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$item dismissed")));
              },
              // Muestra un background rojo a medida que el elemento se elimina
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text('$item'),
                textColor: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
