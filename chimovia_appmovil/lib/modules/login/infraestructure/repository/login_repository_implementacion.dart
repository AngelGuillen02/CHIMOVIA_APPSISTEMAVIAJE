import 'package:chimovia_appmovil/modules/login/domain/datasource/login_datasource.dart';
import 'package:chimovia_appmovil/modules/login/domain/entities/login.dart';
import 'package:chimovia_appmovil/modules/login/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDatasource dataSource;

  LoginRepositoryImpl({required this.dataSource});

  @override
  Future<LoginRespuesta> login(String email, String password) async {
    var obj = await dataSource.login(email, password);
    return obj;
  }
}