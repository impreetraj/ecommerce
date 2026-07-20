import 'package:realm/realm.dart';

part 'product.realm.dart';

@RealmModel()
class _Product {
  @PrimaryKey()
  late ObjectId id;

  late String name;
  late double price;
  late String description;
  late String imagePath;
}

@RealmModel()
class _CartItem {
  @PrimaryKey()
  late ObjectId id;
  
  late ObjectId productId;
  
  late int quantity;
}
