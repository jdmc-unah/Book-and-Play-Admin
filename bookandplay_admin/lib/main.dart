import 'package:bookandplay_admin/controladores/filtro_controlador.dart';
import 'package:bookandplay_admin/estilos/colores.dart';
import 'package:bookandplay_admin/firebase_options.dart';
import 'package:bookandplay_admin/vistas/crud_cancha.dart';
import 'package:bookandplay_admin/vistas/pagina_inicio.dart';
import 'package:bookandplay_admin/vistas/vistas_login/login.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(ControladorFiltros(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colores.fondoPrimario,
          selectionColor: Colores.fondoPrimario,
          selectionHandleColor: Colores.fondoPrimario,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(
        navigatorKey: Get.key,
        redirect: (context, state) {
          final sesionIniciada = GetStorage().read('sesionIniciada') ?? false;
          final rutaActual = state.fullPath;

          if (!sesionIniciada && rutaActual == '/inicio') {
            return '/login';
          }
          return null;
        },
        initialLocation: '/inicio',
        routes: [
          GoRoute(
            name: 'login',
            path: '/login',
            builder: (context, state) => Login(),
          ),

          GoRoute(
            name: 'inicio',
            path: '/inicio',
            builder: (context, state) {
              return PaginaInicio(); //TODO >> pagina de inicio
            },
          ),

          GoRoute(
            name: 'cancha',
            path: '/cancha',
            builder: (context, state) => CRUDCancha(), //TODO>>> para el CRUD
          ),
        ],
      ),
    );
  }
}
