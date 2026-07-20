import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/register.dart';

class RegisterDb {
  static final RegisterDb instance = RegisterDb._init();

  static Database? _database;

  RegisterDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('register.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE users (
  id $idType,
  name $textType,
  email $textType,
  phone $textType,
  password $textType
  )
''');
  }

  Future<String> registerUser(UserModel user) async {
    final db = await instance.database;

  
    final existingUsers = await db.query(
      'users',
      where: 'email = ? OR phone = ?',
      whereArgs: [user.email, user.phone],
    );

    if (existingUsers.isNotEmpty) {
      final existing = UserModel.fromMap(existingUsers.first);
      if (existing.email == user.email) {
        return 'Email already exists';
      } else {
        return 'Phone number already exists';
      }
    }

    await db.insert('users', user.toMap());
    return 'Success';
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final db = await instance.database;

    final maps = await db.query(
      'users',
      columns: ['id', 'name', 'email', 'phone', 'password'],
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> setLoginStatus(bool status) async {
    final db = await instance.database;
    await db.execute('CREATE TABLE IF NOT EXISTS session (isLoggedIn INTEGER)');
    await db.execute('DELETE FROM session');
    await db.insert('session', {'isLoggedIn': status ? 1 : 0});
  }

  Future<bool> getLoginStatus() async {
    final db = await instance.database;
    await db.execute('CREATE TABLE IF NOT EXISTS session (isLoggedIn INTEGER)');
    final result = await db.query('session');
    if (result.isNotEmpty) {
      return result.first['isLoggedIn'] == 1;
    }
    return false;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
