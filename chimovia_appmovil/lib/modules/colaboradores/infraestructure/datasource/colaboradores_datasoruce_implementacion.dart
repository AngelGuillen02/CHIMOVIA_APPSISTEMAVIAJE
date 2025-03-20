// lib/modules/colaboradores/infrastructure/datasources/colaboradores_datasource.dart
import 'dart:convert';

import 'package:chimovia_appmovil/config/helpers/custom_exceptions.dart';
import 'package:chimovia_appmovil/modules/colaboradores/domain/datasource/colaborador_datasource.dart';
import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:dio/dio.dart';
import 'package:chimovia_appmovil/config/enviroment.dart';


class ColaboradoresDataSourceImpl implements ColaboradoresDatasource {
  final Dio _dio = Dio();

  @override
Future<List<Colaboradores>> getColaboradores() async {
    try {
      final response = await _dio.get(
        '${EnviromentApi.apiUrl}/colaboradores/ListadoColaboradores',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final colaboradores = Colaboradores.fromJson(jsonDecode(response.toString()));
      return [colaboradores];
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response?.statusCode == 404) {
        errorMessage = 'No se encontraron colaboradores';
      } else {
        errorMessage = 'Error al obtener colaboradores: ${e.message}';
      }
      throw CustomException(errorMessage);
    }
  }

  @override
 Future<void> addColaborador(Colaboradores colaborador) async {
    try {
      final response = await _dio.post(
        '${EnviromentApi.apiUrl}/colaboradores/CrearColaborador',
        data: colaborador.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode != 200) {
        throw CustomException('Error al agregar colaborador');
      }
    } on DioException catch (e) {
      throw CustomException('Error al agregar colaborador: ${e.message}');
    }
  }
}