import 'dart:convert';

import 'package:cellu_town/model/product.dart';
import 'package:cellu_town/utils/commons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var proid = '0'.obs;
  var itemName = ''.obs;
  var image = ''.obs;
  var price = 0.0.obs;
  var quantity = 1.obs;
  var lineTotal = 0.0.obs;
  var cartTotal = 0.0.obs;

  var cart = {}.obs;

  addToCart() {
    if (proid.value != '0') {
      cart[proid.value] = jsonEncode({
        "id": proid.value,
        "name": itemName.value,
        "price": price.value,
        "quantity": quantity.value,
        "image": image.value,
        "lineTotal": lineTotal.value,
      });
      Get.back();
      findTotal();
    }
  }

  clear() {
    cart.clear();
    findTotal();
    update();
  }

  setCartItemsValues(Product item) {
    proid.value = item.id.toString();
    itemName.value = item.name;
    image.value = item.image;
    price.value = double.parse(item.price.toString());
    quantity.value = 1;
    lineTotal.value = price.value;
  }

  increaseQuantity({item}) {
    if (item != null) {
      proid.value = item["id"].toString();
      itemName.value = item["name"];
      image.value = item["image"];
      price.value = item["price"];
      quantity.value = item["quantity"];
      lineTotal.value = price.value;
    }
    quantity.value++;
    lineTotal.value = price.value * quantity.value;

    if (item != null) {
      addToCart();
    }
  }

  decreaseQuantity({item}) {
    if (item != null) {
      proid.value = item["id"].toString();
      itemName.value = item["name"];
      image.value = item["image"];
      price.value = item["price"];
      quantity.value = item["quantity"];
      lineTotal.value = price.value;
    }
    if (quantity.value > 1) {
      quantity.value--;
      lineTotal.value = price.value * quantity.value;
      if (item != null) {
        addToCart();
      }
    }
  }

  removeFromCart(String id) {
    Get.dialog(
      //alert dialog
      AlertDialog(
        title: Text("Remove Item"),
        content: Text("Are you sure you want to remove this item?"),
        actions: [
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Get.back();
            },
          ),
          FlatButton(
            child: Text("Remove"),
            onPressed: () {
              cart.remove(id);
              findTotal();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  findTotal() {
    cartTotal.value = 0.0;
    for (var element in cart.values) {
      var cartitem = jsonDecode(element);
      cartTotal.value += cartitem["lineTotal"];
    }
  }
}
