import 'package:flutter/material.dart';
import 'package:cellu_town/model/product.dart';
import 'package:cellu_town/utils/apis.dart';
import 'package:cellu_town/utils/commons.dart';
import 'package:cellu_town/utils/custom_http.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductController extends GetxController {
  final LocalStorage storage = new LocalStorage('items');
  List<Product> products = RxList.empty();
  List<Product> filtered = RxList.empty();
  List<Product> wishlist = RxList.empty();
  var searched = "".obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getProducts();
    setWishlist();
  }

  addItem(
      {required name,
      required categoryId,
      required imageFile,
      required des,
      required price,
      required context}) async {
    print('addItem');
    var stream =
        // ignore: deprecated_member_use
        http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(addProductsApi);

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    request.fields['name'] = name;
    request.fields['categoryId'] = categoryId;
    request.fields['description'] = des;
    request.fields['price'] = price;
    // add file to multipart
    request.files.add(multipartFile);

    //get response
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = jsonDecode(responseString);
    if (data["success"]) {
      products.clear();

      data["products"]
          .forEach((element) => products.add(Product.fromJson(element)));
      filterByCategory(categoryId);

      Get.back();
      showMessage(message: data["message"], isError: false);
    } else {
      showMessage(message: data["message"], isError: true);
    }
  }

  editItem(
      {required name,
      required categoryId,
      required imageFile,
      required des,
      required id,
      required price,
      required context}) async {
    if (imageFile != null) {
      var stream =
          // ignore: deprecated_member_use
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();

      // string to uri
      var uri = Uri.parse(editProductsApi);

      // create multipart request
      var request = http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: basename(imageFile.path));
      request.fields['name'] = name;
      request.fields['id'] = id;
      request.fields['categoryId'] = categoryId;
      request.fields['description'] = des;
      request.fields['price'] = price;
      // add file to multipart
      request.files.add(multipartFile);

      //get response
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var data = jsonDecode(responseString);
      if (data["success"]) {
        products.clear();
        data["products"]
            .forEach((element) => products.add(Product.fromJson(element)));
        filterByCategory(categoryId);
        Get.back();
        showMessage(message: data["message"]);
      } else {
        showMessage(message: data["message"], isError: true);
      }
    } else {
      isLoading.value = true;
      var data = {
        "name": name,
        'id': categoryId,
        "description": des,
        "price": price
      };
      var response = await CustomHttp().post(url: editProductsApi, body: data);
      if (response != null) {
        if (response["success"]) {
          data["products"]
              .forEach((element) => products.add(Product.fromJson(element)));
          filterByCategory(categoryId);
          Get.back();
          showMessage(message: data["message"]);
        } else {
          Get.snackbar('Failed', response['message'],
              backgroundColor: Colors.brown, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', "Something Went Wrong.",
            backgroundColor: Colors.brown, colorText: Colors.white);
      }
      isLoading.value = false;
    }

    addCategory({required String category}) async {
      var data = {"category": category};
      var response = await CustomHttp().post(url: addCategoryApi, body: data);
      if (response != null) {
        if (response["success"]) {
          products = response["products"];
          Get.back();
        } else {
          Get.snackbar('Failed', response['message'],
              backgroundColor: Colors.brown, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', "Something Went Wrong.",
            backgroundColor: Colors.brown, colorText: Colors.white);
      }
    }
  }

  deleteItem({required String id, required String categoryId}) async {
    var data = {"id": id};
    var response = await CustomHttp().post(url: deleteProductsApi, body: data);
    if (response != null) {
      if (response["success"]) {
        products.clear();
        response["products"]
            .forEach((element) => products.add(Product.fromJson(element)));
        filterByCategory(categoryId);
        showMessage(message: response["message"]);
      } else {
        Get.snackbar('Failed', response['message'],
            backgroundColor: Colors.brown, colorText: Colors.white);
      }
    } else {
      Get.snackbar('Error', "Something Went Wrong.",
          backgroundColor: Colors.brown, colorText: Colors.white);
    }
    isLoading.value = false;
  }

  getProducts() async {
    var response = await CustomHttp().get(url: getProductsApi);
    if (response != null) {
      if (response["success"]) {
        products.clear();
        response["products"]
            .forEach((element) => products.add(Product.fromJson(element)));
      } else {
        showMessage(message: response["message"], isError: true);
      }
    } else {
      showMessage(message: "Something Went Wrong!", isError: true);
    }
  }

  filterByCategory(String category) {
    filtered.clear();
    products.forEach((element) {
      if (element.categoryId == category) {
        filtered.add(element);
      }
    });
    update();
  }

  filterbySearch({required String search}) {
    searched.value = search;
    filtered.clear();
    products.forEach((element) {
      if (element.name.toLowerCase().contains(search.toLowerCase())) {
        filtered.add(element);
      }
      if (element.categoryId == search) {
        filtered.add(element);
      }
    });
    update();
  }

  setWishlist() async {
    print("before ready: " + storage.getItem("wishlist").toString());
    //wait until ready
    await storage.ready;
    //this will now print 0
    print("after ready: " + storage.getItem("wishlist").toString());
    //set value
    var wishList = storage.getItem("wishlist");
    wishlist.clear();
    if (wishList != null) {
      wishList = jsonDecode(wishList);
      wishList.forEach((element) {
        //convert string to product
        var product = Product.fromJson(element);
        wishlist.add(
          Product(
            id: product.id,
            name: product.name,
            price: product.price,
            image: product.image,
            despcription: product.despcription,
            categoryId: product.categoryId,
          ),
        );
      });
    }
    update();
  }

  removeFromWishList({required Product product}) async {
    //remove where id is equal to product id
    wishlist.removeWhere((element) => element.id == product.id);
    storage.setItem("wishlist", jsonEncode(wishlist));
    update();
  }

  isInWishlist({required Product product}) {
    return (wishlist.where((element) => element.id == product.id).length > 0);
  }

  addToWishlist({required Product product}) async {
    if (isInWishlist(product: product)) {
      removeFromWishList(product: product);
    } else {
      wishlist.add(product);
      storage.setItem("wishlist", jsonEncode(wishlist));
      update();
    }
  }
}
