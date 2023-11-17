import '../../models/citas/paciente.dart';
import '../../models/citas/psicologo.dart';

class RegistroValidate {
String? validarCampos(Pacientes? paciente, Psicologo? psicologo, descripcion, String? estadoCita) {
    if (paciente == null) {
      return 'Por favor, selecciona un paciente.';
    }
    if (psicologo == null) {
      return 'Por favor, selecciona un psicólogo.';
    }
    if (descripcion.isEmpty) {
      return 'La descripción no puede estar vacía.';
    }
    if (estadoCita == null || estadoCita.isEmpty) {
      return 'Por favor, selecciona un estado para la cita.';
    }
    return null; // Si todo está bien, devuelve null.
  }
}