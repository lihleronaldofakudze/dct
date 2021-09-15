import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreams_come_true/models/Cart.dart';
import 'package:dreams_come_true/models/Customer.dart';
import 'package:dreams_come_true/models/Order.dart';
import 'package:dreams_come_true/models/Product.dart';

class DatabaseService {
  final String? uid;
  final String? productId;
  final String? productCategory;
  final String? orderId;
  final String? style;

  DatabaseService(
      {this.uid,
      this.productId,
      this.productCategory,
      this.orderId,
      this.style});

  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('dct_products');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('dct_users');
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('dct_orders');

  //User Existence
  checkForUser() async {
    DocumentSnapshot documentSnapshot = await _usersCollection.doc(uid).get();
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
    return _usersCollection.doc(uid).set({
      'image': image,
      'name': name,
      'address': address,
      'role': role,
      'cartAmount': cartAmount,
    });
  }

  Customer _userFromSnapshot(DocumentSnapshot snapshot) {
    return Customer(
      image: snapshot.get('image'),
      name: snapshot.get('name'),
      address: snapshot.get('address'),
      role: snapshot.get('role'),
      cartAmount: snapshot.get('cartAmount'),
    );
  }

  Stream<Customer> get customer {
    return _usersCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  Future addProduct(
      {required String image,
      required String title,
      required String brand,
      required String style,
      required String sizes,
      required double price,
      required String category}) {
    return _productsCollection.add({
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
    return _productsCollection.doc(productId).update({
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
    return _productsCollection
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
    return _productsCollection
        .doc(productId)
        .snapshots()
        .map(_productFromSnapshot);
  }

  Stream<List<Product>> get productByCategory {
    return _productsCollection
        .where('category', isEqualTo: productCategory)
        .snapshots()
        .map(_productsFromSnapshot);
  }

  Stream<List<Product>> get productByStyles {
    return _productsCollection
        .where('style', isEqualTo: style)
        .snapshots()
        .map(_productsFromSnapshot);
  }

  Stream<List<Product>> get productByStyle {
    return _productsCollection
        .limit(4)
        .orderBy('style')
        .snapshots()
        .map(_productsFromSnapshot);
  }

  Stream<List<Product>> get favorites {
    return _productsCollection
        .where('likes', arrayContains: uid)
        .snapshots()
        .map(_productsFromSnapshot);
  }

  Future deleteProduct() async {
    return _productsCollection.doc(productId).delete();
  }

  //likes
  Future like() {
    return _productsCollection.doc(productId).update({
      'likes': FieldValue.arrayUnion([uid]),
    });
  }

  Future unLike() {
    return _productsCollection.doc(productId).update({
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
        await _usersCollection.doc(uid).collection('cart').doc(productId).get();

    if (documentSnapshot.exists) {
      return null;
    } else {
      return _usersCollection.doc(uid).collection('cart').doc(productId).set({
        'image': image,
        'title': title,
        'style': style,
        'price': price,
        'addedAt': new DateTime.now(),
        'quantity': quantity
      }).then((value) {
        return _usersCollection
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
    return _usersCollection
        .doc(uid)
        .collection('cart')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map(_cartFromSnapshot);
  }

  Future incrementCart({required double price}) {
    return _usersCollection
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .update({'quantity': FieldValue.increment(1)}).then((value) {
      return _usersCollection
          .doc(uid)
          .update({'cartAmount': FieldValue.increment(price)});
    });
  }

  Future decrementCart({required double price}) {
    return _usersCollection
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .update({'quantity': FieldValue.increment(-1)}).then((value) {
      return _usersCollection
          .doc(uid)
          .update({'cartAmount': FieldValue.increment(-price)});
    });
  }

  Future deleteCart() {
    return _usersCollection.doc(uid).collection('cart').doc(productId).delete();
  }

  Future checkOut({required double total, required String orderName}) async {
    QuerySnapshot cart =
        await _usersCollection.doc(uid).collection('cart').get();
    final orderDetails = cart.docs.map((doc) => doc.data()).toList();
    return _ordersCollection.add({
      'uid': uid,
      'orderName': orderName,
      'orderDetails': orderDetails,
      'orderStatus': 'Pending',
      'total': total
    }).then((value) async {
      for (var doc in cart.docs) {
        await doc.reference.delete();
      }
    }).then((value) {
      return _usersCollection.doc(uid).update({'cartAmount': 0.0001});
    });
  }

  Order _orderFromSnapshot(DocumentSnapshot snapshot) {
    List<Cart> cart = [];
    List<dynamic> cartMap = snapshot.get('orderDetails');
    cartMap.forEach((element) {
      cart.add(new Cart(
          id: '',
          image: element['image'],
          title: element['title'],
          style: element['style'],
          price: element['price'],
          addedAt: element['addedAt'],
          quantity: element['quantity']));
    });
    return Order(
        id: snapshot.id,
        uid: snapshot.get('uid'),
        orderName: snapshot.get('orderName'),
        orderStatus: snapshot.get('orderStatus'),
        total: snapshot.get('total'),
        orderDetails: cart);
  }

  List<Order> _ordersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      List<Cart> cart = [];
      List<dynamic> cartMap = doc.get('orderDetails');
      cartMap.forEach((element) {
        cart.add(new Cart(
            id: '',
            image: element['image'],
            title: element['title'],
            style: element['style'],
            price: element['price'],
            addedAt: element['addedAt'],
            quantity: element['quantity']));
      });
      return Order(
          id: doc.id,
          uid: doc.get('uid'),
          orderName: doc.get('orderName'),
          orderStatus: doc.get('orderStatus'),
          total: doc.get('total'),
          orderDetails: cart);
    }).toList();
  }

  Stream<Order> get order {
    return _ordersCollection.doc(orderId).snapshots().map(_orderFromSnapshot);
  }

  Stream<List<Order>> get orders {
    return _ordersCollection.snapshots().map(_ordersFromSnapshot);
  }

  Stream<List<Order>> get customerOrders {
    return _ordersCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_ordersFromSnapshot);
  }

  Future updateOrderStatus({required String status}) {
    return _ordersCollection.doc(orderId).update({'orderStatus': status});
  }

  Future deleteOrder() {
    return _ordersCollection.doc(orderId).delete();
  }
}
