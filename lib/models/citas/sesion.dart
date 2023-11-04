class Sesion {
    Sesion({
        required this.id,
        required this.idCita,
        required this.horaInicio,
        required this.horaFin,
        required this.duracion,
        required this.inicio,
        required this.desarrollo,
        required this.anlisis,
        required this.observaciones,
    });

    final int? id;
    final int? idCita;
    final DateTime? horaInicio;
    final DateTime? horaFin;
    final String? duracion;
    final String? inicio;
    final String? desarrollo;
    final String? anlisis;
    final String? observaciones;

    Sesion copyWith({
        int? id,
        int? idCita,
        DateTime? horaInicio,
        DateTime? horaFin,
        String? duracion,
        String? inicio,
        String? desarrollo,
        String? anlisis,
        String? observaciones,
    }) {
        return Sesion(
            id: id ?? this.id,
            idCita: idCita ?? this.idCita,
            horaInicio: horaInicio ?? this.horaInicio,
            horaFin: horaFin ?? this.horaFin,
            duracion: duracion ?? this.duracion,
            inicio: inicio ?? this.inicio,
            desarrollo: desarrollo ?? this.desarrollo,
            anlisis: anlisis ?? this.anlisis,
            observaciones: observaciones ?? this.observaciones,
        );
    }

    factory Sesion.fromJson(Map<String, dynamic> json){ 
        return Sesion(
            id: json["ID"],
            idCita: json["id_cita"],
            horaInicio: DateTime.tryParse(json["hora_inicio"] ?? ""),
            horaFin: DateTime.tryParse(json["hora_fin"] ?? ""),
            duracion: json["duracion"],
            inicio: json["inicio"],
            desarrollo: json["desarrollo"],
            anlisis: json["análisis"],
            observaciones: json["observaciones"],
        );
    }

    Map<String, dynamic> toJson() => {
        "ID": id,
        "id_cita": idCita,
        "hora_inicio": horaInicio?.toIso8601String(),
        "hora_fin": horaFin?.toIso8601String(),
        "duracion": duracion,
        "inicio": inicio,
        "desarrollo": desarrollo,
        "análisis": anlisis,
        "observaciones": observaciones,
    };

    @override
    String toString(){
        return "$id, $idCita, $horaInicio, $horaFin, $duracion, $inicio, $desarrollo, $anlisis, $observaciones, ";
    }
}
