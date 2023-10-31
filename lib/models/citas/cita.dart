class Citas {
    Citas({
        required this.id,
        required this.descripcion,
        required this.idPaciente,
        required this.idEspecialidad,
        required this.idPsicologo,
        required this.fechaCita,
        required this.horaCita,
        required this.estado,
        required this.createdAt,
    });

    final String? id;
    final String? descripcion;
    final String? idPaciente;
    final String? idEspecialidad;
    final String? idPsicologo;
    final DateTime? fechaCita;
    final String? horaCita;
    final String? estado;
    final String? createdAt;

    Citas copyWith({
        String? id,
        String? descripcion,
        String? idPaciente,
        String? idEspecialidad,
        String? idPsicologo,
        DateTime? fechaCita,
        String? horaCita,
        String? estado,
        String? createdAt,
    }) {
        return Citas(
            id: id ?? this.id,
            descripcion: descripcion ?? this.descripcion,
            idPaciente: idPaciente ?? this.idPaciente,
            idEspecialidad: idEspecialidad ?? this.idEspecialidad,
            idPsicologo: idPsicologo ?? this.idPsicologo,
            fechaCita: fechaCita ?? this.fechaCita,
            horaCita: horaCita ?? this.horaCita,
            estado: estado ?? this.estado,
            createdAt: createdAt ?? this.createdAt,
        );
    }

    factory Citas.fromJson(Map<String, dynamic> json){
        return Citas(
            id: json["id"],
            descripcion: json["descripcion"],
            idPaciente: json["id_paciente"],
            idEspecialidad: json["id_especialidad"],
            idPsicologo: json["id_psicologo"],
            fechaCita: DateTime.tryParse(json["fecha_cita"] ?? ""),
            horaCita: json["hora_cita"],
            estado: json["estado"],
            createdAt: json["created_at"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "id_paciente": idPaciente,
        "id_especialidad": idEspecialidad,
        "id_psicologo": idPsicologo,
        "fecha_cita": "${fechaCita?.year.toString().padLeft(4, '0')}-${fechaCita?.month.toString().padLeft(2, '0')}-${fechaCita?.day.toString().padLeft(2, '0')}",
        "hora_cita": horaCita,
        "estado": estado,
        "created_at": createdAt,
    };

    @override
    String toString(){
        return "$id, $descripcion, $idPaciente, $idEspecialidad, $idPsicologo, $fechaCita, $horaCita, $estado, $createdAt, ";
    }
}