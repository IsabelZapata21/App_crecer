import 'package:flutter_application_2/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthService', () {
    test('Iniciar Sesión Exitoso', () async {
      // Configura el servicio de autenticación
      final authService = AuthService();

      // Realiza la prueba del método iniciarSesion
      final result = await authService.iniciarSesion('ozapatac', 'ozapatac12');

      // Verifica que la respuesta sea exitosa
      expect(result['success'], true);
      // Puedes agregar más aserciones según la estructura específica de tu respuesta
    });

    test('Iniciar Sesión Fallido', () async {
      // Configura el servicio de autenticación
      final authService = AuthService();

      // Realiza la prueba del método iniciarSesion
      final result = await authService.iniciarSesion('usuarioInvalido', 'contraseniaInvalida');

      // Verifica que la respuesta sea fallida
      expect(result['success'], false);
      // Puedes agregar más aserciones según la estructura específica de tu respuesta
    });

    test('Listar Usuarios', () async {
      // Configura el servicio de autenticación
      final authService = AuthService();

      // Realiza la prueba del método listarUsuarios
      final userList = await authService.listarUsuarios();

      // Verifica que la lista de usuarios no sea nula
      expect(userList, isNotNull);
      // Puedes agregar más aserciones según la estructura específica de tu respuesta
    });
  });
}
