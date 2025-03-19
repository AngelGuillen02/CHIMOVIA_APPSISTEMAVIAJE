// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

LoginRespuesta loginFromJson(String str) => LoginRespuesta.fromJson(json.decode(str));

String loginToJson(LoginRespuesta data) => json.encode(data.toJson());

class LoginRespuesta {
    bool isAuthenticated;
    String message;
    int usuarioId;
    String nombre;
    String nombreRol;
    String token;

    LoginRespuesta({
        required this.isAuthenticated,
        required this.message,
        required this.usuarioId,
        required this.nombre,
        required this.nombreRol,
        required this.token,
    });

    factory LoginRespuesta.fromJson(Map<String, dynamic> json) => LoginRespuesta(
        isAuthenticated: json["isAuthenticated"],
        message: json["message"],
        usuarioId: json["usuarioId"],
        nombre: json["nombre"],
        nombreRol: json["nombreRol"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "isAuthenticated": isAuthenticated,
        "message": message,
        "usuarioId": usuarioId,
        "nombre": nombre,
        "nombreRol": nombreRol,
        "token": token,
    };
}
