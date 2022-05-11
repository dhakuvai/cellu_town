import 'dart:convert';
import 'package:cellu_town/components/cart_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:cellu_town/components/custom_button.dart';
import 'package:cellu_town/controllers/cart_controller.dart';
import 'package:cellu_town/controllers/order_controller.dart';
import 'package:cellu_town/utils/apis.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartController = Get.find<CartController>();
  final orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => Column(
                    children: cartController.cart.values.map((item) {
                      return menuItemCard(jsonDecode(item));
                    }).toList(),
                  )),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => cartController.cartTotal.value != 0.0
                  ? CustomButton(
                      onTap: () {
                        Get.bottomSheet(CartBottomSheet());
                      },
                      label: 'Buy Now: ' + cartController.cartTotal.toString(),
                    )
                  : SizedBox()),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      )),
    );
  }

  Widget menuItemCard(item) {
    final cartController = Get.find<CartController>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        //shadow
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                cartController.removeFromCart(item["id"]);
              },
              backgroundColor: Color(0xFF0392CF),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Remove',
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                child: Image.network(
                  baseUrl + item['image'],
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  width: Get.width / 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 1.0),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(item['name'].toString().toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600))),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item['price'].toString(),
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.red),
                            )),
                      ],
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () =>
                            cartController.decreaseQuantity(item: item)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item["quantity"].toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () =>
                            cartController.increaseQuantity(item: item)),
                  ),
                ],
              ),
              const Spacer(),
              Text(item["lineTotal"].toString(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
