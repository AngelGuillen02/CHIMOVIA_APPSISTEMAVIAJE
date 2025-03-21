import 'dart:convert';

import 'package:chimovia_appmovil/config/enums/respuestas_http.dart';
import 'package:chimovia_appmovil/config/helpers/custom_exceptions.dart';
import 'package:chimovia_appmovil/modules/viajes/domain/datasource/viajes_datasoruce.dart';
import 'package:chimovia_appmovil/modules/viajes/domain/entities/viajes.dart';
import 'package:dio/dio.dart';
import 'package:chimovia_appmovil/config/enviroment.dart';
import 'package:flutter/material.dart';

class ViajesDataSourceImpl implements ViajesDatasource {
  final Dio _dio = Dio();

 @override
  Future<List<Viajes>> getViajes() async {
    try {
      final response = await _dio.get(
        '${EnviromentApi.apiUrl}/Viajes/ListadoViajes',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
  

      List<dynamic> responseData;
      if (response.data is String) {
        responseData = jsonDecode(response.data as String);
      } else if (response.data is List) {
        responseData = response.data as List<dynamic>;
      } else {
        throw const FormatException('Unexpected response format');
      }

      final viajes = responseData.map((item) => Viajes.fromJson(item)).toList();
      return viajes;
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response?.statusCode == 404) {
        errorMessage = 'No se encontraron viajes';
      } else {
        errorMessage = 'Error al obtener viajes: ${e.message}';
      }
      debugPrint('DioException: $errorMessage');
      throw CustomException(errorMessage);
    } on FormatException catch (e) {
      debugPrint('FormatException: $e');
      throw CustomException('Error al parsear datos: $e');
    }
  }
@override
  Future<void> addViaje(Viajes viaje) async {
    try {
      final response = await _dio.post(
        '${EnviromentApi.apiUrl}/Viajes/CrearViaje',
        data: viaje.toJson(),
        queryParameters: {'usuarioCreacion': viaje.usuarioId}, 
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      debugPrint('Add Viaje Response Status: ${response.statusCode}');
      debugPrint('Add Viaje Response Data: ${response.data}');
      if (response.statusCode != RespuestasHttp.creado.codigo) {
        final errorMsg = response.data['mensaje'] ?? 'Error al agregar viaje';
        throw CustomException(errorMsg);
      }
    } on DioException catch (e) {
      debugPrint('Add Viaje DioException: ${e.message}');
      final errorMsg = e.response?.data['mensaje'] ?? 'Error al agregar viaje: ${e.message}';
      throw CustomException(errorMsg);
    }
  }
}
