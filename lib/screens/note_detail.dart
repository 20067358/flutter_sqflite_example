import 'package:flutter/material.dart';
import 'package:flutter_sqflite_example/models/note.dart';
import 'dart:async';
import 'package:flutter_sqflite_example/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sqflite_example/models/cabecera_pedido.dart';
import 'package:flutter_sqflite_example/models/detalle_pedido.dart';

class NoteDetail extends StatefulWidget {

  final String appBarTitle;
  //final Note note;
  final DetallePedido detallePedido;
  //final CabeceraPedido cabeceraPedido;

  NoteDetail(this.detallePedido,this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {

  static var _priorities = ['Blanca', 'Amarilla','Roja','Azul'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController cantidadController =  TextEditingController();
  TextEditingController pesoController = TextEditingController();



  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    cantidadController.text = note.title;
    pesoController.text = note.description;

    //**********************  Appbar **************************************
    AppBar appbarDetalle =  AppBar(
      title: Text(appBarTitle),
      leading: IconButton(icon: Icon(
          Icons.arrow_back),
          onPressed: () {
            moveToLastScreen();
          }
      ),
    );
    //*********************************************************************

    // *************     DROPDOWN DE CAJILLAS   ***************************
    Padding pdddb = Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: new Text("Escoge el tipo de cajilla: ",textScaleFactor: 1.25)
    );

    DropdownButton ddbCajillas = DropdownButton(
        items: _priorities.map((String dropDownStringItem) {
          return DropdownMenuItem<String> (
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        style: textStyle,
        value: getPriorityAsString(note.priority),
        onChanged: (valueSelectedByUser) {
          setState(() {
            debugPrint('User selected $valueSelectedByUser');
            updatePriorityAsInt(valueSelectedByUser);
          });
        }
    );

    ListTile ltdropdown = ListTile(
      title: pdddb,
      subtitle: ddbCajillas,
    );
    //*********************************************************************

    // ****************  TEXT DE CANTIDAD DE POLLOS  ***********************

    Padding cantidadPollos =  Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: cantidadController,
        style: textStyle,
        onChanged: (value) {
          debugPrint('Algo cambio en cantidad de pollos');
          updateDescription();
        },
        decoration: InputDecoration(
            labelText: 'Cantidad:',
            labelStyle: textStyle,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
            )
        ),
      ),
    );

    //********************************************************************

    // ******************* TEXT PESO **************************************
    Padding pesoPollos =  Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: pesoController,
        style: textStyle,
        onChanged: (value) {
          debugPrint('Algo cambio en cantidad de pollos');
          updateDescription();
        },
        decoration: InputDecoration(
            labelText: 'Peso:',
            labelStyle: textStyle,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
            )
        ),
      ),
    );

    //*********************************************************************

    // ******************   Boton de Guardar ******************************

      RaisedButton btnGuardar = RaisedButton(
        color: Theme.of(context).primaryColorDark,
        textColor: Theme.of(context).primaryColorLight,
        child: Text(
          'Guardar',
          textScaleFactor: 1.5,
        ),
        onPressed: () {
          setState(() {
            debugPrint("Boton Guardar presionado");
            _save();
          });
        },
      );

    //********************************************************************

    // ******************* Boton Eliminar ********************************
    RaisedButton btnEliminar = RaisedButton(
      color: Theme.of(context).primaryColorDark,
      textColor: Theme.of(context).primaryColorLight,
      child: Text(
        'Borrar',
        textScaleFactor: 1.5,
      ),
      onPressed: () {
        setState(() {
          debugPrint("Delete button clicked");
          _delete();
        });
      },
    );

    //********************************************************************

    // *************  Botones Guardar y eliminar alineados ***************

    Padding btnMenu = Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: btnGuardar,
          ),
          Container(width: 5.0),
          Expanded(
            child: btnEliminar,
          ),
        ],
      ),
    );

    //********************************************************************

    // ************************ Body *************************************

   Padding pdBody = Padding(
      padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
      child: ListView(
        children: <Widget>[
          ltdropdown,
          cantidadPollos,
          pesoPollos,
          btnMenu
        ],
      ),
    );

    //*********************************************************************

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: appbarDetalle,
          body: pdBody
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  //Convierte el texto en entero antes de guardar a la base de datos
  void updatePriorityAsInt(String value) {

    //'Blanca', 'Amarilla','Roja','Azul'
    switch (value) {
      case 'Blanca':
        note.priority = 1;
        break;
      case 'Amarilla':
        note.priority = 2;
        break;
      case 'Roja':
        note.priority = 3;
        break;
      case 'Azul':
        note.priority = 4;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];  // 'Blanca'
        break;
      case 2:
        priority = _priorities[1];  // 'Amarilla'
        break;
      case 3:
        priority = _priorities[0];  // 'Roja'
        break;
      case 4:
        priority = _priorities[1];  // 'Azul'
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle(){
    note.title = cantidadController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = pesoController.text;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    //Ingreso el detalle del pedido, actualmente asumire que el pedido es 1

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {  // Case 1: Update operation
      result = await helper.updateNote(note);
    } else { // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}

