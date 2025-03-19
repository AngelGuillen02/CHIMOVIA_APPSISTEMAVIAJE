import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'login_bloc_event.dart';
part 'login_bloc_state.dart';

class LoginBlocBloc extends Bloc<LoginBlocEvent, LoginBlocState> {
  LoginBlocBloc() : super(LoginBlocInitial()) {
    on<LoginBlocEvent>((event, emit) {
    });
  }
}
