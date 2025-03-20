import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sucursales_bloc_event.dart';
part 'sucursales_bloc_state.dart';

class SucursalesBlocBloc extends Bloc<SucursalesBlocEvent, SucursalesBlocState> {
  SucursalesBlocBloc() : super(SucursalesBlocInitial()) {
    on<SucursalesBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
