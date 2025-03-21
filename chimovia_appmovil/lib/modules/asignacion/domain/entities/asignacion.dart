// To parse this JSON data, do
//
//     final asignacion = asignacionFromJson(jsonString);

import 'dart:convert';

List<Asignacion> asignacionFromJson(String str) => List<Asignacion>.from(json.decode(str).map((x) => Asignacion.fromJson(x)));

String asignacionToJson(List<Asignacion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Asignacion {
    int sucursalColaboradoresDetalleId;
    int sucursalId;
    int colaboradorId;
    dynamic estado;

    Asignacion({
        required this.sucursalColaboradoresDetalleId,
        required this.sucursalId,
        required this.colaboradorId,
        required this.estado,
    });

    factory Asignacion.fromJson(Map<String, dynamic> json) => Asignacion(
        sucursalColaboradoresDetalleId: json["sucursal_Colaboradores_Detalle_Id"],
        sucursalId: json["sucursal_Id"],
        colaboradorId: json["colaborador_Id"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "sucursal_Colaboradores_Detalle_Id": sucursalColaboradoresDetalleId,
        "sucursal_Id": sucursalId,
        "colaborador_Id": colaboradorId,
        "estado": estado,
    };
}
