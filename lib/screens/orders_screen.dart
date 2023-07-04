import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_backend/controllers/order_controller.dart';
import 'package:flutter_ecommerce_backend/controllers/product_controller.dart';
import 'package:flutter_ecommerce_backend/models/models.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  final OrderController orderController = Get.put(OrderController());

  final ProductController productController = Get.put(ProductController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.black,
        bottom: PreferredSize(
            child: TabBar(
                controller: _tabController,
                isScrollable: true,
                unselectedLabelColor: Colors.white.withOpacity(0.3),
                indicatorColor: Colors.white,
                tabs: const [
                  Tab(
                    child: Text('Orders'),
                  ),
                  Tab(
                    child: Text('Acepted'),
                  ),
                  Tab(
                    child: Text('Cancel'),
                  ),
                  Tab(
                    child: Text('Delivery'),
                  ),
                ]),
            preferredSize: Size.fromHeight(30.0)),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Obx(
                  () => ListView.builder(
                    itemCount: orderController.orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderCard(
                        orderController.orders[index],
                        productController.products,
                      );
                    },
                  ),
                ),
                Obx(
                  () => ListView.builder(
                    itemCount: orderController.aceptedOrders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderCard(
                        orderController.aceptedOrders[index],
                        productController.products,
                      );
                    },
                  ),
                ),
                Obx(
                  () => ListView.builder(
                    itemCount: orderController.cancelOrders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderCard(
                        orderController.cancelOrders[index],
                        productController.products,
                      );
                    },
                  ),
                ),
                Obx(
                  () => ListView.builder(
                    itemCount: orderController.deleveryOrders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderCard(
                        orderController.deleveryOrders[index],
                        productController.products,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  OrderCard(Orders order, List<Product> productss) {
    final OrderController orderController = Get.find();

    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        top: 10.0,
        right: 10.0,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID: ${order.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd-MM-yy').format(order.createdAt),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.productIds.length,
                  itemBuilder: (BuildContext context, int index) {
                    var products = productss
                        .where((product) =>
                            product.id == order.productIds[index]['id'])
                        .first;
                    return Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            products.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  products.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'X',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  order.productIds[index]['value'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 280,
                              child: Text(
                                products.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ],
                    );
                  }),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Delivery Fee',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$${order.deliveryFee}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$${order.total}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (order.isAccepted == true && order.isDelivered == false && order.isCancelled == false)
                  ElevatedButton(
                    onPressed: () {
                      orderController.updateOrder(
                        order,
                        "isDelivered",
                        !order.isDelivered,
                        'Enviada'
                      );
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text(
                      'Deliver',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (order.isAccepted == false)
                    ElevatedButton(
                      onPressed: () {
                        orderController.updateOrder(
                          order,
                          "isAccepted",
                          !order.isAccepted,
                          'Aceptada'
                        );
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: const Size(150, 40),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (order.isCancelled == false && order.isDelivered == false)
                    ElevatedButton(
                      onPressed: () {
                        orderController.updateOrder(
                          order,
                          "isCancelled",
                          !order.isCancelled,
                          'Cancelada'
                        );
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: const Size(150, 40),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
