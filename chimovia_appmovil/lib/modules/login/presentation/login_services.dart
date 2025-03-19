
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.17:45455/api/Login/Login',
        data: {
          'Usuario': email,
          'Clave': password,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('Error en la autenticación: ${e.message}');
    }
  }
}