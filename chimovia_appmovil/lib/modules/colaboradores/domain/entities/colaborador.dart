import 'dart:convert';

Colaboradores colaboradoresFromJson(String str) => Colaboradores.fromJson(json.decode(str));

String colaboradoresToJson(Colaboradores data) => json.encode(data.toJson());

class Colaboradores {
  bool valido;
  String mensaje;
  List<Dato> datos;

  Colaboradores({
    required this.valido,
    required this.mensaje,
    required this.datos,
  });

  factory Colaboradores.fromJson(Map<String, dynamic> json) => Colaboradores(
        valido: json["valido"],
        mensaje: json["mensaje"],
        datos: List<Dato>.from(json["datos"].map((x) => Dato.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "valido": valido,
        "mensaje": mensaje,
        "datos": List<dynamic>.from(datos.map((x) => x.toJson())),
      };
}

class Dato {
  int colaboradorId;
  String identidad;
  String nombre;
  String apellido;
  String telefono;
  String email;
  String sexo;
  DateTime fechaNacimiento;
  double? latitud;
  double? longitud;
  String cargoDescripcion;
  int cargoId;
  final String? direccion;

  Dato({
    required this.colaboradorId,
    required this.identidad,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.sexo,
    required this.fechaNacimiento,
    required this.latitud,
    required this.longitud,
    required this.cargoDescripcion,
    required this.cargoId,
    this.direccion,
  });

  factory Dato.fromJson(Map<String, dynamic> json) => Dato(
        colaboradorId: json["colaborador_Id"],
        identidad: json["identidad"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        telefono: json["telefono"],
        email: json["email"],
        sexo: json["sexo"],
        fechaNacimiento: DateTime.parse(json["fecha_Nacimiento"]),
        latitud: json["latitud"]?.toDouble(),
        longitud: json["longitud"]?.toDouble(),
        cargoDescripcion: json["cargoDescripcion"],
        cargoId: json["cargo_Id"],
      );

  Map<String, dynamic> toJson() => {
        "colaborador_Id": colaboradorId,
        "identidad": identidad,
        "nombre": nombre,
        "apellido": apellido,
        "telefono": telefono,
        "email": email,
        "sexo": sexo,
        "fecha_Nacimiento": fechaNacimiento.toIso8601String(),
        "latitud": latitud,
        "longitud": longitud,
        "cargoDescripcion": cargoDescripcion,
        "cargo_Id": cargoId,
      };
}