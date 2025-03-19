// To parse this JSON data, do
//
//     final colaboradores = colaboradoresFromJson(jsonString);

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
    Sexo sexo;
    DateTime fechaNacimiento;
    double? latitud;
    double? longitud;
    CargoDescripcion cargoDescripcion;
    int cargoId;
    int kms;
    int? usuarioModifica;

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
        required this.kms,
        required this.usuarioModifica,
    });

    factory Dato.fromJson(Map<String, dynamic> json) => Dato(
        colaboradorId: json["colaborador_Id"],
        identidad: json["identidad"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        telefono: json["telefono"],
        email: json["email"],
        sexo: sexoValues.map[json["sexo"]]!,
        fechaNacimiento: DateTime.parse(json["fecha_Nacimiento"]),
        latitud: json["latitud"]?.toDouble(),
        longitud: json["longitud"]?.toDouble(),
        cargoDescripcion: cargoDescripcionValues.map[json["cargoDescripcion"]]!,
        cargoId: json["cargo_Id"],
        kms: json["kms"],
        usuarioModifica: json["usuario_Modifica"],
    );

    Map<String, dynamic> toJson() => {
        "colaborador_Id": colaboradorId,
        "identidad": identidad,
        "nombre": nombre,
        "apellido": apellido,
        "telefono": telefono,
        "email": email,
        "sexo": sexoValues.reverse[sexo],
        "fecha_Nacimiento": fechaNacimiento.toIso8601String(),
        "latitud": latitud,
        "longitud": longitud,
        "cargoDescripcion": cargoDescripcionValues.reverse[cargoDescripcion],
        "cargo_Id": cargoId,
        "kms": kms,
        "usuario_Modifica": usuarioModifica,
    };
}

enum CargoDescripcion {
    CHOFER,
    GERENTE,
    PREUAB
}

final cargoDescripcionValues = EnumValues({
    "Chofer": CargoDescripcion.CHOFER,
    "Gerente": CargoDescripcion.GERENTE,
    "Preuab": CargoDescripcion.PREUAB
});

enum Sexo {
    F,
    M
}

final sexoValues = EnumValues({
    "F": Sexo.F,
    "M": Sexo.M
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
