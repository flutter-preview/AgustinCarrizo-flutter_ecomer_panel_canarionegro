import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
   final String? id;
  final String name;
  final String imageUrl;
  final bool activo;

  const Category({
    this.id,
    required this.name,
    required this.imageUrl,
    required this.activo
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
      ];

  static Category fromSnapshot(DocumentSnapshot snap) {
    Category category = Category(
      id: snap.id,
      name: snap['name'],
      imageUrl: snap['imageUrl'],
      activo: snap['activo'],
    );
    return category;
  }


  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'activo' : activo,
    };
  }


}
