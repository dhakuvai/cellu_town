import 'package:cellu_town/controllers/cart_controller.dart';
import 'package:cellu_town/screens/MainScreen.dart';
import 'package:cellu_town/screens/cart_screen.dart';
import 'package:cellu_town/screens/profile_screen.dart';
import 'package:cellu_town/screens/wishlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TabScreenController extends GetxController {
  var currentIndex = 0.obs;
  var isCurrentUserBuyer = true.obs;
  final cartController = Get.find<CartController>();
  PageController pageController = PageController();

  PersistentTabController persistentTabController =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      tabItem(
        'Home',
        icon: const Icon(
          Icons.home_outlined,
        ),
      ),
      tabItem(
        'My Wishlist',
        icon: const Icon(Icons.favorite_border_outlined),
      ),
      tabItem(
        'My Cart',
        icon: Obx(
          () => Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                child: IconBadge(
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black,
                  ),
                  itemCount: cartController.cart.value.length,
                  badgeColor: Colors.red,
                  itemColor: Colors.white,
                  hideZero: true,
                ),
              ),
            ],
          ),
        ),
      ),
      tabItem('My Account', icon: const Icon(Icons.account_circle_outlined)),
    ];
  }

  setCurrentUserToSeller() {
    isCurrentUserBuyer.value = false;
  }

  setCurrentUserToBuyer() {
    isCurrentUserBuyer.value = true;
  }

  PersistentBottomNavBarItem tabItem(title, {required Widget icon, screen}) {
    return PersistentBottomNavBarItem(
      //allow overlap: true,

      textStyle: TextStyle(fontSize: 12),
      icon: icon,
      activeColorSecondary: Colors.blueGrey,
      title: (title),
      activeColorPrimary: Colors.black,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    );
  }

  List<Widget> tabScreen = [
    MainScreen(), //Home
    WishlistScreen(), //My Transactions
    const CartScreen(), //My Transactions
    ProfileScreen(), //Notifications
  ];

  get getcurrentIndex => currentIndex;
  changeCurrentIndex(int index) {
    currentIndex.value = index;
    persistentTabController.index = index;
  }
}
