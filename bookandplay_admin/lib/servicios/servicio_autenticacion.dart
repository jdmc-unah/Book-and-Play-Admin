import 'package:bookandplay_admin/controladores/validaciones_acceso_controlador.dart';
import 'package:bookandplay_admin/servicios/servicio_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final validacionController = Get.put<ValidacionesDeAcceso>(
    ValidacionesDeAcceso(),
  );

  Future<String> inicioSesionUsuario(String correo, String contra) async {
    try {
      //* Hace validacion interna
      final errorInterno = ValidacionesDeAcceso.validaInicioSesion(
        correo,
        contra,
      );

      if (errorInterno != null) {
        validacionController.error = true;
        return errorInterno;
      }

      //* Intenta inicio de sesion
      final cred = await _auth.signInWithEmailAndPassword(
        email: correo,
        password: contra,
      );

      //* Guarda datos usuario
      final docId = await FirestoreService().usuarioDocIdPorCorreo(correo);

      await GetStorage().remove('usuarioDocId');
      if (docId != null) await GetStorage().write('usuarioDocId', docId);

      final perfil = await FirestoreService().traerPerfil(correo);
      if (perfil != null) {
        GetStorage().write('usuarioAvatar', perfil.nombre![0].toUpperCase());
        GetStorage().write('usuarioTelefono', perfil.telefono);
      }

      validacionController.error = false;
      return cred.user!.email.toString();
    } on FirebaseAuthException catch (e) {
      validacionController.error = true;
      return manejaExepcionFireBase(e.code);
    }
  }

  Future<void> cerrarSesion() async {
    try {
      await _auth.signOut();
      await GetStorage().remove('usuarioDocId');
      await GetStorage().erase();
      validacionController.cargando = false;
    } catch (e) {
      // print('ERROR AL SALIR DE LA APP'); //TODO >> manejar este error de log out
    }
  }

  static String manejaExepcionFireBase(String codigo) {
    String error;

    switch (codigo) {
      case 'email-already-in-use':
        error = 'ERROR: Ya existe una cuenta asociada a ese correo';
        break;
      case 'invalid-email':
        error = 'ERROR: El formato del correo es incorrecto';
        break;
      case 'wrong-password':
        error = 'ERROR: La contraseña es incorrecta';
        break;
      case 'user-not-found':
        error = 'ERROR: No se encontró el usuario';
        break;
      case 'weak-password':
        error = 'ERROR: La contraseña es muy débil';
        break;
      case 'invalid-credential':
        error = 'ERROR: Credenciales incorrectas';
        break;
      case 'user-disabled':
        error =
            'ERROR: El usuario esta desactivado.\nFavor comunicarse con el administrador';
        break;
      case 'account-exists-with-different-credential':
        error = 'ERROR: La cuenta existe con otro tipo de autenticación';
        break;
      default:
        error = 'ERROR: Algo salió mal :(';
    }

    return error;
  }
}
