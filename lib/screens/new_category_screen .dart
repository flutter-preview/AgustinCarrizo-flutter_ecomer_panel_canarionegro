import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_backend/models/models.dart';
import 'package:flutter_ecommerce_backend/models/product_model.dart';
import 'package:flutter_ecommerce_backend/services/database_service.dart';
import 'package:flutter_ecommerce_backend/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '/controllers/controllers.dart';

class NewCategoryScreen extends StatefulWidget {
  NewCategoryScreen({Key? key}) : super(key: key);

  @override
  State<NewCategoryScreen> createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {


  final CategoriController categoriController = Get.find();

  StorageService storage = StorageService();

  DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Product'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Card(
                  margin: EdgeInsets.zero,
                  color: Colors.black,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          ImagePicker _picker = ImagePicker();
                          final XFile? _image = await _picker.pickImage(
                              source: ImageSource.gallery);

                          if (_image == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No image was selected.'),
                              ),
                            );
                          }

                          if (_image != null) {
                            await storage.uploadImage(_image);
                            var imageUrl =
                                await storage.getDownloadURL(_image.name);

                            categoriController.newProduct.update(
                                'imageUrl', (_) => imageUrl,
                                ifAbsent: () => imageUrl);
                          }
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Add an Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              categoriController.newProduct['imageUrl'] == null
                  ? Container()
                  : SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.network(
                        categoriController.newProduct['imageUrl'] ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
              const SizedBox(height: 20),
              const Text(
                'Categori Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTextFormField(
                'Product Name',
                'name',
                categoriController,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    var newCategory = Category(
                        name: categoriController.newProduct['name'],
                        imageUrl: categoriController.newProduct['imageUrl'],
                        activo: true);
                    print(newCategory.toMap());

                    database.addCategoris(newCategory);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField(
    String hintText,
    String name,
    CategoriController productController,
  ) {
    return TextFormField(
      decoration: InputDecoration(hintText: hintText),
      onChanged: (value) {
        productController.newProduct.update(
          name,
          (_) => value,
          ifAbsent: () => value,
        );
      },
    );
  }
}
