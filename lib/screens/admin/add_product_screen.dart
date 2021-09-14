import 'dart:io';

import 'package:dreams_come_true/models/Product.dart';
import 'package:dreams_come_true/services/database.dart';
import 'package:dreams_come_true/widget/loading.dart';
import 'package:dreams_come_true/widget/ok_alert_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool _loading = false;
  PickedFile _pickedFile = PickedFile('');
  final _titleController = TextEditingController();
  final _brandController = TextEditingController();
  final _styleController = TextEditingController();
  final _sizesController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = '';
  final _categories = [
    'Sale',
    'Apparel',
    'Footwear',
    'Sportswear',
    'Traditional',
    'Formal Wear',
    'Accessories',
    'Jewelery',
    'Luggage',
    'Cosmetics',
    'Costumes',
    'Textiles',
    'Vintage',
  ];

  selectImage() async {
    await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      setState(() {
        _pickedFile = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<Product>(
      stream: DatabaseService(productId: productId.toString()).product,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Product? product = snapshot.data;
          _titleController.text = product!.title;
          _brandController.text = product.brand;
          _styleController.text = product.style;
          _sizesController.text = product.sizes;
          _priceController.text = product.price.toString();

          return _loading
              ? Loading()
              : Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Update Product',
                      style: GoogleFonts.bellotaText(),
                    ),
                    centerTitle: true,
                    actions: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text('Dreams Come True'),
                                      content: Text(
                                          'Are you want to delete ${product.title} product.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel')),
                                        TextButton(
                                            onPressed: () async {
                                              await DatabaseService(
                                                      productId: product.id)
                                                  .deleteProduct()
                                                  .then((value) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text('Delete')),
                                      ],
                                    ));
                          },
                          icon: Icon(Icons.delete_rounded, color: Colors.red))
                    ],
                  ),
                  body: SingleChildScrollView(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Image',
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                                onPressed: () => selectImage(),
                                icon: Icon(Icons.edit_rounded))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _pickedFile.path == ''
                            ? Container(
                                height: 250,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.brown),
                                    image: DecorationImage(
                                        image: NetworkImage(product.image))),
                              )
                            : Container(
                                height: 250,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.brown),
                                    image: DecorationImage(
                                        image:
                                            FileImage(File(_pickedFile.path)))),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Please enter product details'),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Title'),
                          controller: _titleController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Brand'),
                          controller: _brandController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Style'),
                          controller: _styleController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Sizes'),
                          controller: _sizesController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Price'),
                          controller: _priceController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                          value: product.category,
                          decoration: InputDecoration(labelText: 'Category'),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              child: Text(category),
                              value: category,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _category = value.toString();
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _loading = true;
                                });
                                if (_titleController.text.isNotEmpty &&
                                    _brandController.text.isNotEmpty &&
                                    _styleController.text.isNotEmpty &&
                                    _sizesController.text.isNotEmpty &&
                                    _priceController.text.isNotEmpty &&
                                    _category.isNotEmpty) {
                                  if (_pickedFile.path == '') {
                                    await DatabaseService(productId: product.id)
                                        .updateProduct(
                                            image: product.image,
                                            title: _titleController.text,
                                            brand: _brandController.text,
                                            style: _styleController.text,
                                            sizes: _sizesController.text,
                                            price: double.parse(
                                                _priceController.text),
                                            category: _category)
                                        .then((value) {
                                      setState(() {
                                        _pickedFile = PickedFile('');
                                        _titleController.clear();
                                        _brandController.clear();
                                        _styleController.clear();
                                        _sizesController.clear();
                                        _priceController.clear();
                                        _category = '';
                                        _loading = false;
                                      });
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    Reference reference = FirebaseStorage
                                        .instance
                                        .ref()
                                        .child('dct')
                                        .child(basename(_pickedFile.path));
                                    UploadTask uploadTask = reference
                                        .putFile(File(_pickedFile.path));
                                    uploadTask.whenComplete(() {
                                      reference
                                          .getDownloadURL()
                                          .then((url) async {
                                        await DatabaseService(
                                                productId: product.id)
                                            .updateProduct(
                                                image: url,
                                                title: _titleController.text,
                                                brand: _brandController.text,
                                                style: _styleController.text,
                                                sizes: _sizesController.text,
                                                price: double.parse(
                                                    _priceController.text),
                                                category: _category)
                                            .then((value) {
                                          setState(() {
                                            _pickedFile = PickedFile('');
                                            _titleController.clear();
                                            _brandController.clear();
                                            _styleController.clear();
                                            _sizesController.clear();
                                            _priceController.clear();
                                            _category = '';
                                            _loading = false;
                                          });
                                          Navigator.pop(context);
                                        });
                                      });
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _loading = false;
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (_) => okAlertDialog(
                                          context: context,
                                          message:
                                              'Please enter all product details and image'));
                                }
                              },
                              child: Text('Update Product')),
                        )
                      ],
                    ),
                  ),
                );
        } else {
          return _loading
              ? Loading()
              : Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Add Product',
                      style: GoogleFonts.bellotaText(),
                    ),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Image',
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                                onPressed: () => selectImage(),
                                icon: Icon(Icons.edit_rounded))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.brown),
                              image: DecorationImage(
                                  image: FileImage(File(_pickedFile.path)))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Please enter product details'),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Title'),
                          controller: _titleController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Brand'),
                          controller: _brandController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Style'),
                          controller: _styleController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Sizes'),
                          controller: _sizesController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Price'),
                          controller: _priceController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: 'Category'),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              child: Text(category),
                              value: category,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _category = value.toString();
                            });
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _loading = true;
                                });
                                if (_pickedFile.path.isNotEmpty &&
                                    _titleController.text.isNotEmpty &&
                                    _brandController.text.isNotEmpty &&
                                    _styleController.text.isNotEmpty &&
                                    _sizesController.text.isNotEmpty &&
                                    _priceController.text.isNotEmpty &&
                                    _category.isNotEmpty) {
                                  Reference reference = FirebaseStorage.instance
                                      .ref()
                                      .child('dct')
                                      .child(basename(_pickedFile.path));
                                  UploadTask uploadTask =
                                      reference.putFile(File(_pickedFile.path));
                                  uploadTask.whenComplete(() {
                                    reference
                                        .getDownloadURL()
                                        .then((url) async {
                                      await DatabaseService()
                                          .addProduct(
                                              image: url,
                                              title: _titleController.text,
                                              brand: _brandController.text,
                                              style: _styleController.text,
                                              sizes: _sizesController.text,
                                              price: double.parse(
                                                  _priceController.text),
                                              category: _category)
                                          .then((value) {
                                        setState(() {
                                          _pickedFile = PickedFile('');
                                          _titleController.clear();
                                          _brandController.clear();
                                          _styleController.clear();
                                          _sizesController.clear();
                                          _priceController.clear();
                                          _category = '';
                                          _loading = false;
                                        });
                                        Navigator.pop(context);
                                      });
                                    });
                                  });
                                } else {
                                  setState(() {
                                    _loading = false;
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (_) => okAlertDialog(
                                          context: context,
                                          message:
                                              'Please enter all product details and image'));
                                }
                              },
                              child: Text('Sell Product')),
                        )
                      ],
                    ),
                  ),
                );
        }
      },
    );
  }
}
