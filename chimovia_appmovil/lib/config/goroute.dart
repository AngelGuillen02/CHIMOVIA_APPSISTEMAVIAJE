import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/colaboradores/infraestructure/datasource/colaboradores_datasoruce_implementacion.dart';
import 'package:chimovia_appmovil/modules/login/presentation/login.dart';
import 'package:chimovia_appmovil/modules/login/bloc/login_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/login/infraestructure/datasource/login_datasource_implementacion.dart';
import 'package:chimovia_appmovil/modules/login/infraestructure/repository/login_repository_implementacion.dart';
import 'package:chimovia_appmovil/modules/home/home_screen.dart';
import 'package:chimovia_appmovil/modules/viajes/bloc/viajes_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/viajes/infraestructure/datasource/viajes_datasource_implementacion.dart';
import 'package:chimovia_appmovil/modules/viajes/infraestructure/repository/viaje_repository_implementacion.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../modules/colaboradores/infraestructure/repository/colaborador_repository_implementacion.dart';
final appRoutes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => LoginBlocBloc(
          repository: LoginRepositoryImpl(
            dataSource: LoginDataSourceImplementation(),
          ),
        ),
        child: LoginScreen(),
      ),
      name: 'Login',
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ColaboradoresBloc(
              repository: ColaboradoresRepositoryImpl(
                dataSource: ColaboradoresDataSourceImpl(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => ViajesBlocBloc(
              repository: ViajesRepositoryImpl(
                dataSource: ViajesDataSourceImpl(),
              ),
            ),
          ),
        ],
        child: MainScreen(),
      ),
      name: 'Menu',
    ),
  ],
);
