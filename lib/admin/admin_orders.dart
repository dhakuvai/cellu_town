import 'package:flutter/material.dart';
import 'package:cellu_town/controllers/order_controller.dart';
import 'package:cellu_town/utils/apis.dart';
import 'package:get/get.dart';

class AdminOrders extends GetView<OrderController> {
  const AdminOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Colors.black45,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          GetBuilder<OrderController>(
            init: OrderController(),
            builder: (orderController) => Expanded(
              child: ListView.builder(
                itemCount: orderController.orders.length,
                itemBuilder: (context, index) {
                  print(orderController.orders[index]);
                  return Stack(
                    //allow overflow
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
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
                                    orderController.orders[index]['address']),
                                trailing: Text(
                                  orderController.orders[index]['total'],
                                  style: const TextStyle(fontSize: 20),
                                ),
                                // ignore: unrelated_type_equality_checks
                                subtitle: Text(orderController.orders[index]
                                            ['delivery_status'] ==
                                        '1'
                                    ? "Delivered"
                                    : "Pending"),
                              ),
                              //products
                              if (orderController.orders[index]['products'] !=
                                  null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Name: ' +
                                            orderController.orders[index]
                                                ['name']),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Email: ' +
                                            orderController.orders[index]
                                                ['email']),
                                      ),
                                      Row(
                                        children: [
                                          Text('Payment Type:'),
                                          Text(
                                            orderController.orders[index]
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
                                            .orders[index]['products'].length,
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image.network(
                                                      "$baseUrl/" +
                                                          orderController.orders[
                                                                          index]
                                                                      [
                                                                      'products']
                                                                  [productIndex]
                                                              ['image'],
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    Text(
                                                      orderController.orders[
                                                                      index]
                                                                  ['products']
                                                              [productIndex]
                                                          ['name'],
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      orderController.orders[
                                                                          index]
                                                                      [
                                                                      'products']
                                                                  [productIndex]
                                                              ['quantity'] +
                                                          'pcs',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      orderController.orders[
                                                                      index]
                                                                  ['products']
                                                              [productIndex]
                                                          ['price'],
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      (double.parse(orderController
                                                                              .orders[index]
                                                                          [
                                                                          'products']
                                                                      [
                                                                      productIndex]
                                                                  [
                                                                  'quantity']) *
                                                              (double.parse(orderController
                                                                          .orders[index]
                                                                      ['products']
                                                                  [productIndex]['price'])))
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
                      ),
                      Positioned(
                          top: -8,
                          right: 20,
                          child: CircleAvatar(
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Get.bottomSheet(Container(
                                  color: Colors.white,
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        //change status
                                        const Text(
                                          'Change Status To:',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        //delivered
                                        ElevatedButton(
                                          onPressed: () {
                                            orderController.changeStatus(
                                                orderId: orderController
                                                    .orders[index]['id']);
                                            Get.back();
                                          },
                                          child: Text(
                                              orderController.orders[index]
                                                          ['delivery_status'] ==
                                                      '1'
                                                  ? "Pending"
                                                  : "Delivered"),
                                        ),
                                        //pending
                                      ],
                                    ),
                                  ),
                                ));
                              },
                            ),
                          ))
                    ],
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
