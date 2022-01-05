import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:e_wallet/app/data/model/card_model.dart';

class CardDatabase {
  static final CardDatabase instance = CardDatabase._init();
  static Database? _database;
  CardDatabase._init(); //? constructor

  Future<Database> get database async {
    if (_database != null) {
      return _database!; //? returns the database if alreasy exists
    } else {
      _database = await _initDB('ewallet.db');
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    Directory dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
    print(' db final path - $path');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final stringType = 'TEXT NOT NULL';
    final numberType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableCards (
      ${CardFields.id} $idType,
      ${CardFields.name} $stringType,
      ${CardFields.number} $numberType,
      ${CardFields.expDate} $stringType,
      ${CardFields.cvvNumber} $numberType,
      ${CardFields.cardType} $stringType,
      ${CardFields.cardManufacturer} $stringType,
      ${CardFields.cardColor} $stringType
    )
    ''');
    // print('database created');
  }

  Future<CardModel> create(CardModel cardModel) async {
    final db = await instance.database;

    final id = await db.insert(tableCards, cardModel.toJson());
    print('create id - $id');

    return cardModel.copy(id: id);
  }

//? to read a single row
  Future<CardModel> readCard(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableCards,
      columns: CardFields.values,
      where: '${CardFields.id} = ?',
      whereArgs: [id],
    );

    //? now we have the convert the above map to node object
    if (maps.isNotEmpty) {
      print('maps - $maps');
      return CardModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  // ? to read all row
  Future<List<CardModel>> readAllCards() async {
    final db = await instance.database;
    final orderBy = '${CardFields.id} DESC'; //? to order in ascending order
    print('order by - $orderBy');

    // final result =
    //     await db.rawQuery('SELECT * FROM $tableCards ORDER BY $orderBy');

    final result = await db.query(tableCards, orderBy: orderBy);
    print(result);
    //? convert the json to card mobel object
    return result.map((json) => CardModel.fromJson(json)).toList();
  }

// ? update our database
  Future<int> update(CardModel cardModel) async {
    final db = await instance.database;

    return db.update(
      tableCards,
      cardModel.toJson(),
      where: '${CardFields.id} = ?',
      whereArgs: [cardModel.id], //? update only the object which has the id
    );
  }

  //? to delete
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableCards,
      where: '${CardFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
