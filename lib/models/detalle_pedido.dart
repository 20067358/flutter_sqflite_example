class DetallePedido {
  int _idPedido;
  int _id;
  double _peso;
  double _cantidad;

  DetallePedido(this._idPedido,this._id,this._cantidad,this._peso);


  //getter
  int get idPedido => _idPedido;
  int get id => _id;
  double get peso => _peso;
  double get cantidad => _cantidad;

  //setter

  set idPedido(int nuevoidCabecera){
    this._idPedido = nuevoidCabecera;
  }
  set id(int nuevoID){
    this._id = nuevoID;
  }
  set peso(double nuevoPeso){
    this._peso = nuevoPeso;
  }
  set cantidad(double nuevaCantidad){
    this._cantidad = nuevaCantidad;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if (id !=null){
      map['id'] = _id;
    }
    map['idPedido'] = _idPedido;
    map['peso'] = _peso;
    map['cantidad'] = _cantidad;
    return map;
  }


  DetallePedido.fromMapObject(Map<String,dynamic> map){
    this._id =map['id'];
    this._idPedido = map['idPedido'];
    this._peso = map['peso'];
    this._cantidad = map['cantidad'];
  }
}

