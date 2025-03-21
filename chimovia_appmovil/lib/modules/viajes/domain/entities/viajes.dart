// viajes.dart
import 'dart:convert';

List<Viajes> viajesFromJson(String str) => List<Viajes>.from(json.decode(str).map((x) => Viajes.fromJson(x)));

String viajesToJson(List<Viajes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Viajes {
  int viajeId;
  String descripcion;
  double distanciaParcial;
  DateTime fecha;
  String horaLlegada;
  int transportistaId;  
  int sucursalId;       
  String nombreUsuario; 
  int usuarioId;
  List<Detalle> detalles;

  Viajes({
    required this.viajeId,
    required this.descripcion,
    required this.distanciaParcial,
    required this.fecha,
    required this.horaLlegada,
    required this.transportistaId,
    required this.sucursalId,
    required this.nombreUsuario,
    required this.usuarioId,
    required this.detalles,
  });

  factory Viajes.fromJson(Map<String, dynamic> json) => Viajes(
        viajeId: json["viaje_Id"],
        descripcion: json["descripcion"],
        distanciaParcial: json["distancia_Parcial"]?.toDouble() ?? 0.0,
        fecha: DateTime.parse(json["fecha"]),
        horaLlegada: json["hora_Llegada"],
        transportistaId: json["transportista_Id"] ?? 0, 
        sucursalId: json["sucursal_Id"] ?? 0,           
        nombreUsuario: json["nombreUsuario"],
        usuarioId: json["usuario_Id"],
        detalles: List<Detalle>.from(json["detalles"].map((x) => Detalle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "viaje_Id": viajeId,
        "descripcion": descripcion,
        "fecha": fecha.toIso8601String(),
        "hora_Llegada": horaLlegada,
        "transportista_Id": transportistaId,
        "sucursal_Id": sucursalId,
        "usuario_Id": usuarioId,
        "colaboradores": detalles.map((d) => d.colaboradorId).toList(), // Send collaborator IDs
      };
}

class Detalle {
  int viajeDetalleId;
  double distanciaTotal;
  double costo;
  DateTime fecha;
  int? solicitudViajeId;
  int viajeId;
  int colaboradorId;
  int? usuarioId;

  Detalle({
    required this.viajeDetalleId,
    required this.distanciaTotal,
    required this.costo,
    required this.fecha,
    this.solicitudViajeId,
    required this.viajeId,
    required this.colaboradorId,
    this.usuarioId,
  });

  factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        viajeDetalleId: json["viaje_Detalle_Id"],
        distanciaTotal: json["distancia_Total"]?.toDouble() ?? 0.0,
        costo: json["costo"]?.toDouble() ?? 0.0,
        fecha: DateTime.parse(json["fecha"]),
        solicitudViajeId: json["solicitud_Viaje_Id"],
        viajeId: json["viaje_Id"],
        colaboradorId: json["colaborador_Id"],
        usuarioId: json["usuario_Id"],
      );

  Map<String, dynamic> toJson() => {
        "viaje_Detalle_Id": viajeDetalleId,
        "distancia_Total": distanciaTotal,
        "costo": costo,
        "fecha": fecha.toIso8601String(),
        "solicitud_Viaje_Id": solicitudViajeId,
        "viaje_Id": viajeId,
        "colaborador_Id": colaboradorId,
        "usuario_Id": usuarioId,
      };
}