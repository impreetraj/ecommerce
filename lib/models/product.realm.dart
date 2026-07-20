// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Product extends _Product with RealmEntity, RealmObjectBase, RealmObject {
  Product(
    ObjectId id,
    String name,
    double price,
    String description,
    String imagePath,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'imagePath', imagePath);
  }

  Product._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override
  set price(double value) => RealmObjectBase.set(this, 'price', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get imagePath =>
      RealmObjectBase.get<String>(this, 'imagePath') as String;
  @override
  set imagePath(String value) => RealmObjectBase.set(this, 'imagePath', value);

  @override
  Stream<RealmObjectChanges<Product>> get changes =>
      RealmObjectBase.getChanges<Product>(this);

  @override
  Stream<RealmObjectChanges<Product>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Product>(this, keyPaths);

  @override
  Product freeze() => RealmObjectBase.freezeObject<Product>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'price': price.toEJson(),
      'description': description.toEJson(),
      'imagePath': imagePath.toEJson(),
    };
  }

  static EJsonValue _toEJson(Product value) => value.toEJson();
  static Product _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'price': EJsonValue price,
        'description': EJsonValue description,
        'imagePath': EJsonValue imagePath,
      } =>
        Product(
          fromEJson(id),
          fromEJson(name),
          fromEJson(price),
          fromEJson(description),
          fromEJson(imagePath),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Product._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Product, 'Product', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('price', RealmPropertyType.double),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('imagePath', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class CartItem extends _CartItem
    with RealmEntity, RealmObjectBase, RealmObject {
  CartItem(ObjectId id, ObjectId productId, int quantity) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'productId', productId);
    RealmObjectBase.set(this, 'quantity', quantity);
  }

  CartItem._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get productId =>
      RealmObjectBase.get<ObjectId>(this, 'productId') as ObjectId;
  @override
  set productId(ObjectId value) =>
      RealmObjectBase.set(this, 'productId', value);

  @override
  int get quantity => RealmObjectBase.get<int>(this, 'quantity') as int;
  @override
  set quantity(int value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  Stream<RealmObjectChanges<CartItem>> get changes =>
      RealmObjectBase.getChanges<CartItem>(this);

  @override
  Stream<RealmObjectChanges<CartItem>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<CartItem>(this, keyPaths);

  @override
  CartItem freeze() => RealmObjectBase.freezeObject<CartItem>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'productId': productId.toEJson(),
      'quantity': quantity.toEJson(),
    };
  }

  static EJsonValue _toEJson(CartItem value) => value.toEJson();
  static CartItem _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'productId': EJsonValue productId,
        'quantity': EJsonValue quantity,
      } =>
        CartItem(fromEJson(id), fromEJson(productId), fromEJson(quantity)),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(CartItem._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, CartItem, 'CartItem', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('productId', RealmPropertyType.objectid),
      SchemaProperty('quantity', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
