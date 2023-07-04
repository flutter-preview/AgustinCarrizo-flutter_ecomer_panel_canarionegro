import 'package:flutter_ecommerce_backend/models/models.dart';
import 'package:flutter_ecommerce_backend/services/database_service.dart';
import 'package:get/get.dart';

class CategoriController extends GetxController {
  final DatabaseService database = DatabaseService();

  var categorys = <Category>[].obs;

  @override
  void onInit() {
    categorys.bindStream(database.getCategorys());
    super.onInit();
  }

  var newProduct = {}.obs;

  get price => newProduct['price'];
  get quantity => newProduct['quantity'];
  get isRecommended => newProduct['isRecommended'];
  get isPopular => newProduct['isPopular'];

  void saveNewProductPrice(
    Product product,
    String field,
    double value,
  ) {
    database.updateField(product, field, value);
  }

  void saveNewProductQuantity(
    Product product,
    String field,
    int value,
  ) {
    database.updateField(product, field, value);
  }

  void deleteproduct(Category product, dynamic newvalue) {
    database.deletecategory(product, newvalue);
  }
}
