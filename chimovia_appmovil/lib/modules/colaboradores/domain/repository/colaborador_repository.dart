
import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';

abstract class ColaboradoresRepository {
  
  Future<List<Colaboradores>> getColaboradores();

  Future<void> addColaborador(Colaboradores colaborador);

}