import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'viajes_bloc_event.dart';
part 'viajes_bloc_state.dart';

class ViajesBlocBloc extends Bloc<ViajesBlocEvent, ViajesBlocState> {
  ViajesBlocBloc() : super(ViajesBlocInitial()) {
    on<ViajesBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
