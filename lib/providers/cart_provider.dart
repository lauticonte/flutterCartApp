import 'package:flutter/material.dart';
import 'package:practica4/models/cart_model.dart';
import 'package:practica4/models/cart_response_wrapper.dart';
import 'package:practica4/models/catelog.dart';
import 'package:practica4/models/flutter_cart.dart';

class CartProvider extends ChangeNotifier {
  var flutterCart = FlutterCart();
  late CartResponseWrapper cartResponseWrapper;

  get items => null;
  addToCart(Item _productElement, {int funcQuantity = 0}) async {
    cartResponseWrapper = flutterCart.addToCart(
        productId: _productElement.id,
        unitPrice: _productElement.price,
        productName: _productElement.name,
        quantity: funcQuantity == 0 ? 1 : funcQuantity,
        productDetailsObject: _productElement);
    notifyListeners();
  }

  bool cartIsEmpty() {
    return flutterCart.cartItem.length == 0;
  }

  deleteItemFromCart(int index) async {
    cartResponseWrapper = flutterCart.deleteItemFromCart(index);
    notifyListeners();
  }

  decrementItemFromCartProvider(int index) async {
    cartResponseWrapper = flutterCart.decrementItemFromCart(index);
    notifyListeners();
  }

  incrementItemToCartProvider(int index) async {
    cartResponseWrapper = flutterCart.incrementItemToCart(index);
    notifyListeners();
  }

  int? findItemIndexFromCartProvider(cartId) {
    int? index = flutterCart.findItemIndexFromCart(cartId);
    return index;
  }

  CartItem? getSpecificItemFromCartProvider(id) {
    CartItem? cartItem = flutterCart.getSpecificItemFromCart(id);

    if (cartItem != null) {
      print(
          "Name ${cartItem.productDetails.name} Quantity ${cartItem.quantity}");
      return cartItem;
    }
    return cartItem;
  }

  double getTotalAmount() {
    return flutterCart.getTotalAmount();
  }

  List<CartItem> getCartItems() {
    return flutterCart.cartItem;
  }

  printCartValue() {
    flutterCart.cartItem.forEach((f) => {
          print(f.productId),
          print(f.quantity),
        });
  }

  deleteAllCartProvider() {
    flutterCart.deleteAllCart();
  }

  void incrementItemFromCartProvider(int index) {}
}
