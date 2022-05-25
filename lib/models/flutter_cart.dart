import 'package:flutter/material.dart';

import 'package:practica4/models/cart_model.dart';
import 'package:practica4/models/cart_response_wrapper.dart';

class FlutterCart {
  static final FlutterCart _instance = FlutterCart._internal();
  late CartItem _cartItem;

  late List<CartItem> _cartItemList;
  List<CartItem> get cartItem => _cartItemList;
  late List<String> _uuid;
  bool _filterItemFound = false;
  late CartResponseWrapper message;
  factory FlutterCart() {
    return _instance;
  }
  FlutterCart._internal() {
    _cartItemList = <CartItem>[];
    _uuid = [];
  }

  addToCart(
      {@required dynamic productId,
      @required dynamic unitPrice,
      String? productName,
      int quantity = 1,
      dynamic uniqueCheck,
      dynamic productDetailsObject}) {
    _cartItem = new CartItem();
    _setProductValues(productId, unitPrice, productName, quantity, uniqueCheck,
        productDetailsObject);
    if (_cartItemList.isEmpty) {
      _cartItem.subTotal =
          double.parse((quantity * unitPrice).toStringAsFixed(2));
      _uuid.add(_cartItem.uuid);
      _cartItemList.add(_cartItem);

      message = CartResponseWrapper(true, _successMessage, _cartItemList);
      return message;
    } else {
      _cartItemList.forEach((x) {
        if (x.productId == productId) {
          if (uniqueCheck != null) {
            if (x.uniqueCheck == uniqueCheck) {
              _filterItemFound = true;
              _updateProductDetails(x, quantity, unitPrice);

              message =
                  CartResponseWrapper(true, _updateMessage, _cartItemList);
            }
          } else {
            _filterItemFound = true;
            _updateProductDetails(x, quantity, unitPrice);
            message = CartResponseWrapper(true, _successMessage, _cartItemList);
          }
        }
      });

      if (!_filterItemFound) {
        _uuid.add(_cartItem.uuid);
        _updateProductDetails(_cartItem, quantity, unitPrice);
        _cartItemList.add(_cartItem);
        message = CartResponseWrapper(true, _successMessage, _cartItemList);
      }
      _filterItemFound = false;
      return message;
    }
  }

  decrementItemFromCart(int index) {
    if (_cartItemList[index].quantity > 1) {
      _cartItemList[index].quantity = --_cartItemList[index].quantity;
      _cartItemList[index].subTotal =
          (_cartItemList[index].quantity * _cartItemList[index].unitPrice)
              .roundToDouble();
    } else {
      _cartItemList.removeAt(index);
      return CartResponseWrapper(true, _removedMessage, _cartItemList);
    }
    return CartResponseWrapper(true, _removedMessage, _cartItemList);
  }

  deleteItemFromCart(int index) {
    for (int i = _cartItemList[index].quantity; i > 0; i--) {
      decrementItemFromCart(index);
    }
    message = CartResponseWrapper(true, _successMessage, _cartItemList);
    return message;
  }

  deleteAllCart() {
    _cartItemList = <CartItem>[];
    _uuid = <String>[];
  }

  int? findItemIndexFromCart(cartId) {
    for (int i = 0; i < _cartItemList.length; i++) {
      if (_cartItemList[i].productId == cartId) {
        return i;
      }
    }
    return null;
  }

  CartItem? getSpecificItemFromCart(cartId) {
    for (int i = 0; i < _cartItemList.length; i++) {
      if (_cartItemList[i].productId == cartId) {
        _cartItemList[i].itemCartIndex = i;
        return _cartItemList[i];
      }
    }
    return null;
  }

  incrementItemToCart(int index) {
    _cartItemList[index].quantity = ++_cartItemList[index].quantity;
    _cartItemList[index].subTotal =
        (_cartItemList[index].quantity * _cartItemList[index].unitPrice)
            .roundToDouble();

    return CartResponseWrapper(true, _successMessage, _cartItemList);
  }

  void _setProductValues(productId, unitPrice, productName, int quantity,
      uniqueCheck, productDetailsObject) {
    _cartItem.uuid =
        productId.toString() + "-" + DateTime.now().toIso8601String();
    _cartItem.productId = productId;
    _cartItem.unitPrice = unitPrice;
    _cartItem.productName = productName;
    _cartItem.quantity = quantity;
    _cartItem.uniqueCheck = uniqueCheck;
    _cartItem.productDetails = productDetailsObject;
  }

  void _updateProductDetails(cartObject, int quantity, dynamic unitPrice) {
    cartObject.quantity = quantity;
    cartObject.subTotal =
        double.parse((quantity * unitPrice).toStringAsFixed(2));
  }

  getCartItemCount() {
    return _cartItemList.length;
  }

  getTotalAmount() {
    double totalAmount = 0.0;
    _cartItemList.forEach((e) => totalAmount += e.subTotal);
    return totalAmount;
  }

  static final String _successMessage = "Item added to cart successfully.";
  static final String _updateMessage = "Item updated successfully.";
  static final String _removedMessage = "Item removed from cart successfully.";
}
