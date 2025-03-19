// lib/modules/colaboradores/infraestructure/repository/colaboradores_repository_impl.dart
import 'package:chimovia_appmovil/modules/colaboradores/domain/datasource/colaborador_datasource.dart';
import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:chimovia_appmovil/modules/colaboradores/domain/repository/colaborador_repository.dart';

class ColaboradoresRepositoryImpl implements ColaboradoresRepository {
  final ColaboradoresDatasource dataSource;

  ColaboradoresRepositoryImpl({required this.dataSource});

  @override
  Future<List<Colaboradores>> getColaboradores() async {
    var response = await dataSource.getColaboradores();
    return response;  
  }

  @override
  Future<void> addColaborador(Colaboradores colaborador) async {
    await dataSource.addColaborador(colaborador);
  }
}
