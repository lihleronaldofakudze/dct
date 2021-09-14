import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreams_come_true/models/Cart.dart';
import 'package:dreams_come_true/models/Customer.dart';
import 'package:dreams_come_true/models/Product.dart';

class DatabaseService {
  final String? uid;
  final String? productId;
  final String? productCategory;

  DatabaseService({this.uid, this.productId, this.productCategory});

  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('dct_products');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('dct_users');
  final CollectionReference paymentsCollection =
      FirebaseFirestore.instance.collection('dct_payments');

  //User Existence
  checkForUser() async {
    DocumentSnapshot documentSnapshot = await usersCollection.doc(uid).get();
    if (documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  //Edit User Profile
  Future editUserProfile(
      {required String image,
      required String name,
      required String address,
      required String role,
      required double cartAmount}) async {
    return usersCollection.doc(uid).set({
      'image': image,
      'name': name,
      'address': address,
      'role': role,
      'cartAmount': cartAmount
    });
  }

  Customer _userFromSnapshot(DocumentSnapshot snapshot) {
    return Customer(
        image: snapshot.get('image'),
        name: snapshot.get('name'),
        address: snapshot.get('address'),
        role: snapshot.get('role'),
        cartAmount: snapshot.get('cartAmount'));
  }

  Stream<Customer> get customer {
    return usersCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  Future addProduct(
      {required String image,
      required String title,
      required String brand,
      required String style,
      required String sizes,
      required double price,
      required String category}) {
    return productsCollection.add({
      'image': image,
      'title': title,
      'brand': brand,
      'style': style,
      'sizes': sizes,
      'price': price,
      'category': category,
      'likes': [],
      'colors': [],
      'postedAt': DateTime.now()
    });
  }

  Future updateProduct({
    required String image,
    required String title,
    required String brand,
    required String style,
    required String sizes,
    required double price,
    required String category,
  }) {
    return productsCollection.doc(productId).update({
      'image': image,
      'title': title,
      'brand': brand,
      'style': style,
      'sizes': sizes,
      'price': price,
      'category': category,
    });
  }

  List<Product> _productsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Product(
          id: doc.id,
          title: doc.get('title'),
          image: doc.get('image'),
          brand: doc.get('brand'),
          sizes: doc.get('sizes'),
          style: doc.get('style'),
          category: doc.get('category'),
          price: doc.get('price'),
          likes: doc.get('likes'),
          postedAt: doc.get('postedAt'));
    }).toList();
  }

  Stream<List<Product>> get products {
    return productsCollection
        .orderBy('postedAt', descending: true)
        .snapshots()
        .map(_productsFromSnapshot);
  }

  Product _productFromSnapshot(DocumentSnapshot snapshot) {
    return Product(
        id: snapshot.id,
        title: snapshot.get('title'),
        image: snapshot.get('image'),
        brand: snapshot.get('brand'),
        sizes: snapshot.get('sizes'),
        style: snapshot.get('style'),
        likes: snapshot.get('likes'),
        category: snapshot.get('category'),
        price: snapshot.get('price'),
        postedAt: snapshot.get('postedAt'));
  }

  Stream<Product> get product {
    return productsCollection
        .doc(productId)
        .snapshots()
        .map(_productFromSnapshot);
  }

  Stream<List<Product>> get productByCategory {
    return productsCollection
        .where('category', isEqualTo: productCategory)
        .snapshots()
        .map(_productsFromSnapshot);
  }

  Stream<List<Product>> get favorites {
    return productsCollection
        .where('likes', arrayContains: uid)
        .snapshots()
        .map(_productsFromSnapshot);
  }

  Future deleteProduct() async {
    return productsCollection.doc(productId).delete();
  }

  //likes
  Future like() {
    return productsCollection.doc(productId).update({
      'likes': FieldValue.arrayUnion([uid]),
    });
  }

  Future unLike() {
    return productsCollection.doc(productId).update({
      'likes': FieldValue.arrayRemove([uid]),
    });
  }

  Future addToCart(
      {required String image,
      required String title,
      required String style,
      required double price,
      required int quantity}) async {
    DocumentSnapshot documentSnapshot =
        await usersCollection.doc(uid).collection('cart').doc(productId).get();

    if (documentSnapshot.exists) {
      return null;
    } else {
      return usersCollection.doc(uid).collection('cart').doc(productId).set({
        'image': image,
        'title': title,
        'style': style,
        'price': price,
        'addedAt': new DateTime.now(),
        'quantity': quantity
      }).then((value) {
        return usersCollection
            .doc(uid)
            .update({'cartAmount': FieldValue.increment(price)});
      });
    }
  }

  List<Cart> _cartFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Cart(
          id: doc.id,
          title: doc.get('title'),
          image: doc.get('image'),
          style: doc.get('style'),
          price: doc.get('price'),
          addedAt: doc.get('addedAt'),
          quantity: doc.get('quantity'));
    }).toList();
  }

  Stream<List<Cart>> get cart {
    return usersCollection
        .doc(uid)
        .collection('cart')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map(_cartFromSnapshot);
  }

  Future incrementCart({required double price}) {
    return usersCollection
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .update({'quantity': FieldValue.increment(1)}).then((value) {
      return usersCollection
          .doc(uid)
          .update({'cartAmount': FieldValue.increment(price)});
    });
  }

  Future decrementCart({required double price}) {
    return usersCollection
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .update({'quantity': FieldValue.increment(-1)}).then((value) {
      return usersCollection
          .doc(uid)
          .update({'cartAmount': FieldValue.increment(-price)});
    });
  }

  Future deleteCart() {
    return usersCollection.doc(uid).collection('cart').doc(productId).delete();
  }

  cartTotal() async {
    QuerySnapshot cart =
        await usersCollection.doc(uid).collection('cart').get();
    List<DocumentSnapshot> myCart = cart.docs;
    return myCart.length; // Count of Documents in Collection
  }
}
