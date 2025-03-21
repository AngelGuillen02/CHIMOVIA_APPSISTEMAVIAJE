import 'dart:convert';
import 'package:chimovia_appmovil/config/enums/respuestas_http.dart';
import 'package:chimovia_appmovil/config/enviroment.dart';
import 'package:chimovia_appmovil/config/helpers/custom_exceptions.dart';
import 'package:chimovia_appmovil/modules/asignacion/domain/datasource/asignacion_datasource.dart';
import 'package:chimovia_appmovil/modules/asignacion/domain/entities/asignacion.dart';
import 'package:dio/dio.dart';

class AsignacionesDataSourceImpl implements AsignacionesDatasource {
    final Dio _dio = Dio();

  @override
  Future<List<Asignacion>> getAsignaciones() async {
    try {
      final response = await _dio.get(
        '${EnviromentApi.apiUrl}/SucursalesColaboradores/ListadoSucursalesColaboradores',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final asignaciones = asignacionFromJson(jsonDecode(response.toString()));
      return asignaciones;
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response?.statusCode == 404) {
        errorMessage = 'No se encontraron asignaciones';
      } else {
        errorMessage = 'Error al obtener asignaciones: ${e.message}';
      }
      throw CustomException(errorMessage);
    }
  }

  @override
  Future<void> addAsignacion(Asignacion asignacion) async {
    try {
      final response = await _dio.post(
        '${EnviromentApi.apiUrl}/SucursalesColaboradores/CrearAsignacion',
        data: asignacion.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode != RespuestasHttp.creado.codigo) {
        throw CustomException('Error al agregar asignación');
      }
    } on DioException catch (e) {
      throw CustomException('Error al agregar asignación: ${e.message}');
    }
  }
}
