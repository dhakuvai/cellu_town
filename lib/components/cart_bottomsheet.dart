import 'package:cellu_town/components/custom_button.dart';
import 'package:cellu_town/controllers/cart_controller.dart';
import 'package:cellu_town/controllers/order_controller.dart';
import 'package:cellu_town/screens/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartBottomSheet extends StatefulWidget {
  CartBottomSheet({Key? key}) : super(key: key);

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  final cartController = Get.find<CartController>();
  final orderController = Get.find<OrderController>();
  String selectedPayment = '1';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Select Payment Type')),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  paymentSelector(
                    value: '1',
                  ),
                  paymentSelector(
                      value: '2', type: 'COD', image: "assets/images/cod.png"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  //remove underlines
                  decoration: const InputDecoration(
                    hintText: 'Enter your delivery address',
                  ),
                  onChanged: (value) {
                    orderController.address.value = value;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  //remove underlines
                  decoration: const InputDecoration(
                    hintText: 'Enter your Phone Number',
                  ),
                  //accept only numbers
                  keyboardType: TextInputType.number,

                  onChanged: (value) {
                    orderController.phone.value = value;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Hero(
                tag: 'payment',
                child: CustomButton(
                    onTap: () {
                      // orderController.placeOrder(
                      //     transaction_token: 'dsadsa');
                      if (orderController.validate()) {
                        if (selectedPayment == '1') {
                          Get.bottomSheet(WalletPayment(
                              onsuccess: (token) => orderController.placeOrder(
                                  transaction_token: token)));
                        } else {
                          orderController.placeOrder(
                              transaction_token: 'COD', method: '2');
                        }
                      }
                    },
                    label: 'Proceed'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentSelector({
    image = 'assets/images/khalti.png',
    type = "khalti",
    value = '1',
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPayment = value.toString();
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              //shadow
              border: Border.all(
                color: selectedPayment == value ? Colors.red : Colors.grey,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                ),
              ],
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: 90,
                    height: 50,
                  ),
                ),
                Text(type.toString().toUpperCase(),
                    style: TextStyle(fontSize: 13)),
              ],
            )),
      ),
    );
  }
}
