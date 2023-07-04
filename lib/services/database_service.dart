
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_backend/models/models.dart';
import 'package:flutter_ecommerce_backend/services/notification.dart';


class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<Stream<List<Orders>>> getOrders() async {
     
    return _firebaseFirestore
        .collection('orders')
        .where('isAccepted', isEqualTo: false)
        .where('isCancelled', isEqualTo: false)
        .where('isDelivered', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Orders.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Orders>> getPendingOrders() {
    return _firebaseFirestore
        .collection('orders')
        .where('isAccepted', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Orders.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Orders>> getAceptedOrders() {
    return _firebaseFirestore
        .collection('orders')
        .where('isAccepted', isEqualTo: true)
        .where('isCancelled', isEqualTo: false)
        .where('isDelivered', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Orders.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Orders>> getCancelOrders() {
    return _firebaseFirestore
        .collection('orders')
        .where('isCancelled', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Orders.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Orders>> getDeleveryOrders() {
    return _firebaseFirestore
        .collection('orders')
        .where('isDelivered', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Orders.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Product>> getProducts() {
    return _firebaseFirestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Category>> getCategorys() {
    return _firebaseFirestore
        .collection('categories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList();
    });
  }

  Future<List<OrderStats>> getOrderStats() {
    return _firebaseFirestore
        .collection('order_stats')
        .orderBy('dateTime')
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .asMap()
            .entries
            .map((entry) => OrderStats.fromSnapshot(entry.value, entry.key))
            .toList());
  }

  Future<void> addProduct(Product product) {
    return _firebaseFirestore.collection('products').add(product.toMap());
  }

  Future<void> addCategoris(Category category) {
    return _firebaseFirestore.collection('categories').add(category.toMap());
  }

  Future<void> updateField(
    Product product,
    String field,
    dynamic newValue,
  ) {
    return _firebaseFirestore
        .collection('products')
        .doc(product.id)
        .get()
        .then((querySnapshot) => {
              querySnapshot.reference.update({field: newValue})
            });
  }

  Future<void> deleteproduct(
    Product product,
    dynamic newValue,
  ) {
    return _firebaseFirestore
        .collection('products')
        .doc(product.id)
        .get()
        .then((querySnapshot) => {
              querySnapshot.reference.update({'activo': newValue})
            });
  }

  Future<void> deletecategory(
    Category product,
    dynamic newValue,
  ) {
    return _firebaseFirestore
        .collection('categories')
        .doc(product.id)
        .get()
        .then((querySnapshot) => {
              querySnapshot.reference.update({'activo': newValue})
            });
  }

  Future<void> updateOrder(
    Orders order,
    String field,
    dynamic newValue,
  ) {
    return _firebaseFirestore
        .collection('orders')
        .where('createdAt', isEqualTo: order.createdAt)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.first.reference.update({field: newValue})
            });
  }
}
