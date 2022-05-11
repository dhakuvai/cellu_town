import 'package:flutter/material.dart';
import 'package:cellu_town/controllers/order_controller.dart';
import 'package:cellu_town/utils/apis.dart';
import 'package:get/get.dart';

class MyOrders extends GetView<OrderController> {
  const MyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.filterMyOrders(controller.orders);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Text('My orders'),
      ),
      body: Column(
        children: [
          //get builder MyOrders
          GetBuilder<OrderController>(
            init: OrderController(),
            builder: (orderController) => Expanded(
              child: ListView.builder(
                itemCount: orderController.myoders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Address: ' +
                                orderController.myoders[index]['address']),
                            trailing: Text(
                              orderController.myoders[index]['total'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            // ignore: unrelated_type_equality_checks
                            subtitle: Text(orderController.myoders[index]
                                        ['delivery_status'] ==
                                    '1'
                                ? "Delivered"
                                : "Pending"),
                          ),
                          //products
                          if (orderController.myoders[index]['products'] !=
                              null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Name: ' +
                                        orderController.myoders[index]['name']),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Email: ' +
                                        orderController.myoders[index]
                                            ['email']),
                                  ),
                                  Row(
                                    children: [
                                      Text('Payment Type:'),
                                      Text(
                                        orderController.myoders[index]
                                                    ['payment_method'] ==
                                                '2'
                                            ? 'Cash On Delivery'
                                            : 'Online | KHALTI',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: orderController
                                        .myoders[index]['products'].length,
                                    itemBuilder: (context, productIndex) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          border: Border.all(
                                            color: Colors.black12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10,
                                              offset: Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image.network(
                                                  "$baseUrl/" +
                                                      orderController.myoders[
                                                                      index]
                                                                  ['products']
                                                              [productIndex]
                                                          ['image'],
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                Text(
                                                  orderController.myoders[index]
                                                          ['products']
                                                      [productIndex]['name'],
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  orderController.myoders[index]
                                                                  ['products']
                                                              [productIndex]
                                                          ['quantity'] +
                                                      'pcs',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  orderController.myoders[index]
                                                          ['products']
                                                      [productIndex]['price'],
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  (double.parse(orderController.myoders[
                                                                          index]
                                                                      ['products']
                                                                  [productIndex]
                                                              ['quantity']) *
                                                          (double.parse(orderController
                                                                              .myoders[
                                                                          index]
                                                                      ['products']
                                                                  [productIndex]
                                                              ['price'])))
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ]),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
