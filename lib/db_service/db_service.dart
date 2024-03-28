import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:user_management/models/user.dart';

class DbService {
  static final DbService _dbService = DbService._internal();

  DbService._internal();

  factory DbService() {
    return _dbService;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final dbName = join(dbPath, 'userdb');

    print(dbName);
    return await openDatabase(dbName, onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Users(id TEXT PRIMARY KEY, name TEXT, email TEXT, age INTEGER)');
    print('TABLE CREATE');
  }

  //raw query
  Future<List<UserModel>> getUserRaw() async {
    final db = await DbService().database;
    final data = await db.rawQuery('SELECT * FROM Users');
    List<UserModel> users =
        List.generate(data.length, (index) => UserModel.fromJson(data[index]));
    return users;
  }

  Future<void> insertUserRaw(UserModel userModel) async {
    final db = await DbService().database;
    db.rawInsert('INSERT INTO Users (id, name, email, age) VALUES (?,?,?,?)',
        [userModel.id, userModel.name, userModel.email, userModel.age]);
    print('INSERT SUCCESS');
  }

  Future<void> updateUserRaw(UserModel userModel) async {
    final db = await DbService().database;
    db.rawUpdate('UPDATE Users SET name = ?, email = ?, age = ? WHERE id = ?',
        [userModel.name, userModel.email, userModel.age, userModel.id]);
    print('UPDATE SUCCESS');
  }

  Future<void> deleteUserRaw(String id) async {
    final db = await DbService().database;
    db.rawDelete('DELETE FROM Users WHERE id =?', [id]);
    print('DELETE SUCCESS');
  }

  //Sql helper
  Future<List<UserModel>> getUser() async {
    final db = await DbService().database;
    final data = await db.query('Users');
    List<UserModel> users =
        List.generate(data.length, (index) => UserModel.fromJson(data[index]));
    return users;
  }

  Future<void> insertUser(UserModel userModel) async {
    final db = await DbService().database;
    try {
      final int result = await db.insert('Users', userModel.toJson());
      if (result != 0) {
        print('INSERT SUCCESS');
      } else {
        print('INSERT FAILED');
      }
    } catch (e) {
      print('INSERT ERROR: $e');
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    final db = await DbService().database;
    await db.update('Users', userModel.toJson(),
        where: 'id =?', whereArgs: [userModel.id]);
    print('UPDATE SUCCESS');
  }

  Future<void> deleteUser(UserModel userModel) async {
    final db = await DbService().database;
    await db.delete('Users', where: 'id =?', whereArgs: [userModel.id]);
    print('DELETE SUCCESS');
  }
}
