import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_sqflite_example/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sqflite_example/models/cabecera_pedido.dart';
import 'package:flutter_sqflite_example/models/detalle_pedido.dart';


class DatabaseHelper{

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  //******* Definiciones de base de datos cabecera pedido ****************************

  String  cabeceraPedidoTable = 'cabecera_pedido_tbl';
  String  colidCab = "id";
  String  colfechaCab = "fecha";
  String  colstatusCab = "status";
  String  coltotalPesoCab = "pesoTotal";
  String  coltotalCantidadCab = "cantidadTotal";
  String  colfacturaSapCab = "facturaSAP";

  //*********************************************************************************

  // ******************** Definicion de detalle pedido ******************************
  String detallePedidoTable = 'detalle_pedido_tbl';
  String  colidDet = "id";
  String  colidCabeceraDet = "idpedido";
  String  colPesoDet = "peso";
  String  colCantidadDet = "cantidad";
  //*********************************************************************************


  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'pedidos.db';

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE  $cabeceraPedidoTable($colidCab INTEGER PRIMARY KEY AUTOINCREMENT,'
                                   '$colfechaCab    TEXT, '
                                   '$colstatusCab   INTEGER, '
                                   '$coltotalCantidadCab REAL, '
                                   '$coltotalPesoCab REAL,'
                                   '$colfacturaSapCab STRING)');


    await db.execute('CREATE TABLE $detallePedidoTable('
                                  '$colidDet INTEGER, '
                                  '$colidCabeceraDet INTEGER, '
                                  '$colCantidadDet REAL, '
                                  '$colPesoDet REAL,'
                                  'PRIMARY KEY($colidDet,$colidCabeceraDet)');
  }


  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  //************* Query de todas las cabeceras de pedidos *******************//
  Future<List<Map<String, dynamic>>> getPedidosMapList() async {
    Database db = await this.database;
    var result = await db.query(cabeceraPedidoTable, orderBy: '$colstatusCab ASC');
    return result;
  }
  //************************************************************************//

  //************* Query de todos los detalles de pedidos *******************//
  Future<List<Map<String, dynamic>>> getDetallePedidosMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $detallePedidoTable');
    return result;
  }
  //************************************************************************//


  Future<List<DetallePedido>> getDetalleList() async {

    var detalleMapList = await getDetallePedidosMapList(); // Get 'Map List' from database
    int count = detalleMapList.length;         // Count the number of map entries in db table

    List<DetallePedido> detalleList = List<DetallePedido>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      detalleList.add(DetallePedido.fromMapObject(detalleMapList[i]));
    }

    return detalleList;
  }

  //************* Ingresar ifnormación en Cabecera ************************//



  //**********************************************************************//

  //************* Ingresar información en Detalle ************************//
  Future<int> insertDetallePedido(DetallePedido detalle) async {
    Database db = await this.database;
    var result = await db.insert(detallePedidoTable, detalle.toMap());
    return result;
  }
  //**********************************************************************//



  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getNoteList() async {

    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count = noteMapList.length;         // Count the number of map entries in db table

    List<Note> noteList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

}