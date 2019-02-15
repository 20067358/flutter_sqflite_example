
class CabeceraPedido{
  int _id;
  String _fecha;
  int _status;
  double _totalPeso;
  double _totalCantidad;
  String _facturaSap;

  CabeceraPedido(this._totalPeso,this._totalCantidad);
  CabeceraPedido.withID(this._id,this._totalPeso,this._totalCantidad);
  CabeceraPedido.updateFacturaSap(this._id,this._facturaSap);


  //Getter
  int get id => _id;
  String get fecha =>_fecha;
  int get status => _status;
  double get totalPeso => _totalPeso;
  double get totalCantida => _totalCantidad;
  String get facturaSAP => _facturaSap;


  //Setters
  set fecha(String nuevaFecha){
      this._fecha = nuevaFecha;
  }

  set status(int nuevoStatus){
    this._status = nuevoStatus;
  }

  set totalPeso(double nuevoPeso){
    this._totalPeso = nuevoPeso;
  }

  set totalCantidad(double nuevaCantidad){
    this._totalCantidad = nuevaCantidad;
  }

  set facturaSap(String nuevaFacturaSap){
    this._facturaSap = nuevaFacturaSap;
  }

  //convert object into a MAP object
  //key es string
  //value es dynamic ya que tenemos tipos mezclados
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if (id !=null){
      map['id'] = _id;
    }

    map['fecha'] = _fecha;
    map['status'] = _status;
    map['totalPeso'] = _totalPeso;
    map['totalCantidad'] = _totalCantidad;
    map['facturaSap'] = _facturaSap;
    return map;
  }

  CabeceraPedido.fromMapObject(Map<String,dynamic> map){
    this._id =map['id'];
    this._fecha = map['fecha'];
    this._status = map['status'];
    this._totalCantidad = map['totalCantidad'];
    this._totalPeso   = map['totalPeso'];
    this._facturaSap = map['facturaSap'];
  }
}