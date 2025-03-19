import 'package:chimovia_appmovil/modules/login/domain/repository/login_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBlocBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  final LoginRepository repository;
  
 LoginBlocBloc({required this.repository}) : super(LoginBlocInitial()) {
    on<ClickEnBotonDeIniciarSesion>((event, emit) async {
      emit(LoginBlocLoading());
      try {
        final respuesta = await repository.login(event.email, event.password);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', respuesta.token);
        if(respuesta.isAuthenticated){
          emit(LoginBlocSuccess(token: respuesta.token));
        }
        else{
          emit(LoginBlocFailure(message: respuesta.message));
        }
      } catch (e) {
        emit(LoginBlocFailure(message: e.toString()));
      }
    });
  }
}
