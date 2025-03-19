import 'dart:convert';

import 'package:chimovia_appmovil/config/enviroment.dart';
import 'package:chimovia_appmovil/config/helpers/custom_exceptions.dart';
import 'package:chimovia_appmovil/modules/login/domain/datasource/login_datasource.dart';
import 'package:chimovia_appmovil/modules/login/domain/entities/login.dart';
import 'package:dio/dio.dart';

class LoginDataSourceImplementation implements LoginDatasource {
  final Dio _dio = Dio();

  @override
  Future<LoginRespuesta> login(String email, String password) async {
    try {

      final response = await _dio.post(
        '${EnviromentApi.apiUrl}/Login/Login',
        data: {
          'Usuario': email,
          'Clave': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      var loginRespuesta = LoginRespuesta.fromJson(
        jsonDecode(response.toString())
      );      

      return loginRespuesta;
    } on DioException catch (e) {
      String errorMessage = '';
      if(e.response!.statusCode == 401){
        errorMessage = 'Usuario o contraseña incorrectos';
      }else{
        errorMessage = 'Error en la autenticación: ${e.message}';
      }
      throw CustomException(errorMessage);
    }
  }
}