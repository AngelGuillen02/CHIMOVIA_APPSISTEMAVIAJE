import 'package:chimovia_appmovil/modules/login/domain/entities/login.dart';

abstract class LoginDatasource {
  Future<LoginRespuesta> login(String email, String password);
}
