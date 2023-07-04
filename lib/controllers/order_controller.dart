import 'package:flutter_ecommerce_backend/models/models.dart';
import 'package:flutter_ecommerce_backend/services/database_service.dart';
import 'package:flutter_ecommerce_backend/services/notification.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final DatabaseService database = DatabaseService();

  var orders = <Orders>[].obs;
  var pendingOrders = <Orders>[].obs;
  var aceptedOrders = <Orders>[].obs;
  var cancelOrders = <Orders>[].obs;
  var deleveryOrders = <Orders>[].obs;
  @override
  void onInit() async {
    orders.bindStream(await database.getOrders());
    aceptedOrders.bindStream(database.getAceptedOrders());
    cancelOrders.bindStream(database.getCancelOrders());
    deleveryOrders.bindStream(database.getDeleveryOrders());
    super.onInit();
  }

  void updateOrder(
    Orders order,
    String field,
    bool value,
    String tipo,
  ) async {
    await database.updateOrder(order, field, value);
    await NotificationFMC()
        .sennotification('Tu ornden', 'Tu orden fue $tipo', order.customerId);
  }
}
