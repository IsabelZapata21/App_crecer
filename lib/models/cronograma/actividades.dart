class Actividades {
    Actividades({
        required this.idAct,
        required this.nombre,
        required this.descripcion,
        required this.fechaInicio,
        required this.fechaFin,
        required this.responsable,
        required this.estado,
    });

    final String? idAct;
    final String? nombre;
    final String? descripcion;
    final DateTime? fechaInicio;
    final DateTime? fechaFin;
    final String? responsable;
    final String? estado;

    Actividades copyWith({
        String? idAct,
        String? nombre,
        String? descripcion,
        DateTime? fechaInicio,
        DateTime? fechaFin,
        String? responsable,
        String? estado,
    }) {
        return Actividades(
            idAct: idAct ?? this.idAct,
            nombre: nombre ?? this.nombre,
            descripcion: descripcion ?? this.descripcion,
            fechaInicio: fechaInicio ?? this.fechaInicio,
            fechaFin: fechaFin ?? this.fechaFin,
            responsable: responsable ?? this.responsable,
            estado: estado ?? this.estado,
        );
    }

    factory Actividades.fromJson(Map<String, dynamic> json){
        return Actividades(
            idAct: json["id_act"],
            nombre: json["nombre"],
            descripcion: json["descripcion"],
            fechaInicio: DateTime.tryParse(json["fecha_inicio"] ?? ""),
            fechaFin: DateTime.tryParse(json["fecha_fin"] ?? ""),
            responsable: json["responsable"],
            estado: json["estado"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id_act": idAct,
        "nombre": nombre,
        "descripcion": descripcion,
        "fecha_inicio": fechaInicio?.toIso8601String(),
        "fecha_fin": fechaFin?.toIso8601String(),
        "responsable": responsable,
        "estado": estado,
    };

    @override
    String toString(){
        return "$idAct, $nombre, $descripcion, $fechaInicio, $fechaFin, $responsable, $estado, ";
    }
}
