import 'package:cellu_town/controllers/categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cellu_town/components/product_tile.dart';
import 'package:cellu_town/controllers/products_controller.dart';
import 'package:get/get.dart';
import '../colors.dart';

class MainScreen extends StatefulWidget {
  final controller = Get.find<ProductController>();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final categoriesController = Get.find<CategoriesController>();
  var search = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Container(
            height: Get.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Colors.grey,
                  Colors.white,
                  Colors.green,
                ])),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    _middleView(),
                    Obx(() => Container(
                        child: widget.controller.searched.trim() == ""
                            ? all()
                            : searched()))
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget searched() {
    return Expanded(child: Container(
      child: GetX<ProductController>(builder: (productController) {
        return Container(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                children: [
                  for (var index = 0;
                      index < productController.filtered.length;
                      index++)
                    ProductTile(
                        is_wishlist: productController.isInWishlist(
                            product: productController.filtered[index]),
                        onWishlist: () => productController.addToWishlist(
                            product: productController.filtered[index]),
                        product: productController.filtered[index],
                        index: index)
                ],
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
            ));
      }),
    ));
  }

  Widget all() {
    return Expanded(child: Container(
      child: GetX<ProductController>(builder: (productController) {
        return Container(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                children: [
                  for (var index = 0;
                      index < productController.products.length;
                      index++)
                    ProductTile(
                        is_wishlist: productController.isInWishlist(
                            product: productController.products[index]),
                        onWishlist: () => productController.addToWishlist(
                            product: productController.products[index]),
                        product: productController.products[index],
                        index: index)
                ],
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
            ));
      }),
    ));
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: AppColors.gray,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Icon(
            Icons.navigate_before,
            color: AppColors.black,
          ),
        ),
        Container(
          child: SvgPicture.asset(
            "assets/images/signs.svg",
            height: 30,
            width: 20,
          ),
        )
      ],
    );
  }

  Widget _middleView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: AppColors.gray),
          child: TextField(
            onChanged: (value) =>
                widget.controller.filterbySearch(search: value),
            cursorColor: AppColors.black,
            style: TextStyle(color: AppColors.black, fontSize: 16),
            decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: AppColors.black,
                ),
                hintText: "What are you looking for?",
                hintStyle: TextStyle(color: AppColors.black, fontSize: 16),
                border: InputBorder.none),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Categories',
              style: TextStyle(color: Colors.white),
            )),
        Row(
          children: [
            InkWell(
              onTap: () {
                widget.controller.filterbySearch(search: "");
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: AppColors.gray),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("All"),
                    )),
              ),
            ),
            Expanded(child: Container(height: 40, child: _horizontalList(5)))
          ],
        )
      ],
    );
  }

  ListView _horizontalList(int n) {
    return ListView(
        scrollDirection: Axis.horizontal,
        children: categoriesController.categories.value
            .map((e) => InkWell(
                  onTap: () {
                    search = e["id"];
                    widget.controller.filterbySearch(search: e["id"]);
                    // widget.controller.searched.value = e["category"];
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: AppColors.gray),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(e["category"]),
                        )),
                  ),
                ))
            .toList());
  }
}
