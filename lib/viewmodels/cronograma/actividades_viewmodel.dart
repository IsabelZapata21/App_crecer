class RegistroValidate {
String? validarCampos(String nombre, String descripcion, String? estadoCita) {
    if (descripcion.isEmpty) {
      return 'La descripción no puede estar vacía.';
    }
    if (estadoCita == null || estadoCita.isEmpty) {
      return 'Por favor, selecciona un estado para la cita.';
    }
    return null; // Si todo está bien, devuelve null.
  }
}