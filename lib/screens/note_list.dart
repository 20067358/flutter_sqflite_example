import 'package:flutter/material.dart';
import 'package:flutter_sqflite_example/screens/note_detail.dart';
import 'dart:async';
//import 'package:flutter_sqflite_example/models/note.dart';
import 'package:flutter_sqflite_example/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_sqflite_example/models/detalle_pedido.dart';
import 'package:flutter_sqflite_example/models/cabecera_pedido.dart';

class NoteList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<DetallePedido> detallePedidoList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (detallePedidoList == null) {
      detallePedidoList = List<DetallePedido>();
      updateListView();
    }


    // ************  Definición de AppBar ***********************

    AppBar appBarPrincipal = AppBar(
      title: Text('Detalle de Pesaje'),
    );


    // ************  Definición de boton de agregar *************
    FloatingActionButton flAgregar = FloatingActionButton(
      onPressed: () {
        debugPrint('FAB clicked');
        navigateToDetail(DetallePedido(1,1,0,0), 'Crear Nuevo detalle pedido');
      },
      tooltip: 'Agregar Pesaje',
      child: Icon(Icons.add),
    );



    return Scaffold(
      appBar: appBarPrincipal,
      body: getNoteListView(),
      floatingActionButton: flAgregar,
    );
  }

  ListView getNoteListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(

            leading: CircleAvatar(
              backgroundColor: Colors.greenAccent,
              child: getPriorityIcon(1),
            ),

            title: Text(this.detallePedidoList[position].cantidad.toString(), style: titleStyle),
            subtitle: Text(this.detallePedidoList[position].peso.toString()),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, detallePedidoList[position]);
              },
            ),
            onTap: () {
              debugPrint("Detalle tapped");
              navigateToDetail(this.detallePedidoList[position],'Editar detalle');
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.blue;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, DetallePedido detalle) async {
    int result = await databaseHelper.deleteNote(detalle.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(DetallePedido detalle, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(detalle, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<DetallePedido>> noteListFuture = databaseHelper.getDetallePedidosList();
      noteListFuture.then((noteList) {
        setState(() {
          this.detallePedidoList= noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}