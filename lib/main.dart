import 'package:cellu_town/screens/splash/splash_screen.dart';
import 'package:cellu_town/screens/tab_screen/tab_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:cellu_town/admin/admin_home.dart';
import 'package:cellu_town/admin/products_screen.dart';
import 'package:cellu_town/auth_checker.dart';
import 'package:cellu_town/controllers/cart_controller.dart';
import 'package:cellu_town/controllers/categories_controller.dart';
import 'package:cellu_town/controllers/order_controller.dart';
import 'package:cellu_town/controllers/products_controller.dart';
import 'package:cellu_town/screens/home_screeen.dart';
import 'package:cellu_town/screens/login_screen.dart';
import 'package:cellu_town/screens/my_orders.dart';
import 'package:cellu_town/screens/signup_screen.dart';
import 'package:get/get.dart';
import 'package:khalti/khalti.dart';
import 'controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  Get.put(ProductController());
  Get.put(CartController());
  Get.put(OrderController());
  Get.put(CategoriesController());
  await Khalti.init(
    publicKey: 'test_public_key_f3ad06b0b67a48d79f4095af0fb2c817',
    enabledDebugging: true,
  );
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    // transition slow
    transitionDuration: Duration(milliseconds: 350),
    // default transition
    defaultTransition: Transition.rightToLeft,
    initialRoute: '/',
    getPages: [
      GetPage(
        name: '/',
        page: () => AuthChecker(),
      ),
      GetPage(
        name: '/splash',
        page: () => SplashScreen(),
      ),
      GetPage(
        name: '/login',
        page: () => LoginScreen(),
      ),
      GetPage(
        name: '/signup',
        page: () => SignupScreen(),
      ),
      GetPage(
        name: '/home',
        page: () => TabScreenPage(),
      ),
      GetPage(
        name: '/admin',
        page: () => AdminHome(),
      ),
      GetPage(
        name: '/product-screen',
        page: () => ProductScreen(),
      ),
      GetPage(
        name: '/my-orders',
        page: () => MyOrders(),
      ),
    ],
  ));
}
