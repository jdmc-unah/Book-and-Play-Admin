import 'package:bookandplay_admin/controladores/validaciones_acceso_controlador.dart';
import 'package:bookandplay_admin/estilos/colores.dart';
import 'package:bookandplay_admin/servicios/servicio_autenticacion.dart';
import 'package:bookandplay_admin/widgets/widgets_login/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

class Login extends StatelessWidget {
  Login({super.key});

  //*Instancias de servicios
  final _auth = AuthService();
  final validacionController = Get.put<ValidacionesDeAcceso>(
    ValidacionesDeAcceso(),
  );

  final _correo = TextEditingController();
  final _contra = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          //*Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              "assets/imagenes/fondologin_transp.png",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Obx(() {
              if (validacionController.cargando) {
                //* Animacion de carga
                return Center(
                  child: CircularProgressIndicator(
                    color: Colores.fondoPrimario,
                  ),
                );
              }
              //* Contenido Login
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Text(
                    '¡Bienvenido!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Text('Ingresa tu usuario y contraseña para iniciar'),
                    ],
                  ),

                  SizedBox(height: 30),

                  LoginTextField(
                    prefixIcon: Icons.email_outlined,
                    topText: 'Correo ',
                    hintText: 'Ingrese su correo',
                    controller: _correo,
                  ),

                  SizedBox(height: 10),

                  LoginTextField(
                    prefixIcon: Icons.lock_outline_sharp,
                    topText: 'Contraseña ',
                    hintText: 'Ingrese su contraseña',
                    activarSuffix: true,
                    controller: _contra,
                  ),

                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colores.fondoPrimario,
                        foregroundColor: Colores.textoSecundario,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        validacionController.cargando = true;

                        //* Ejecuta el inicio de sesion
                        String? response = await _auth.inicioSesionUsuario(
                          _correo.text.trim(),
                          _contra.text.trim(),
                        );

                        if (!context.mounted) return;
                        accionesInicioSesion(context, response);
                      },
                      child: Text('Iniciar Sesión'),
                    ),
                  ),

                  SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colores.fondoComplementoN,
                        ),
                      ),
                      Text(
                        ' ó ',
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Colores.fondoComplementoN,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        '¿No tienes una cuenta?  ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all(
                            Colores.fondoSecundario,
                          ),
                        ),
                        onPressed: () {
                          //TODO >> Referir al usuario a mandarnos un correo
                        },
                        child: Text(
                          'Contáctanos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colores.fondoPrimario,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  accionesInicioSesion(BuildContext context, String? response) {
    if (validacionController.error == false && response != null) {
      if (!context.mounted) return;
      GetStorage().write('sesionIniciada', true);
      context.goNamed('inicio');
    } else {
      validacionController.cargando = false;
      if (!context.mounted) return;

      if (response == null) return;

      ValidacionesDeAcceso.mostrarSnackBar(context, response, true, () {});
    }
  }
}
