class Horarios {
    Horarios({
        required this.id,
        required this.idPsicologo,
        required this.nombre,
        required this.horaInicioM,
        required this.horaFinM,
        required this.horaInicioT,
        required this.horaFinT,
        required this.estado,
    });

    final int? id;
    final int? idPsicologo;
    final String? nombre;
    final String? horaInicioM;
    final String? horaFinM;
    final String? horaInicioT;
    final String? horaFinT;
    final int? estado;

    Horarios copyWith({
        int? id,
        int? idPsicologo,
        String? nombre,
        String? horaInicioM,
        String? horaFinM,
        String? horaInicioT,
        String? horaFinT,
        int? estado,
    }) {
        return Horarios(
            id: id ?? this.id,
            idPsicologo: idPsicologo ?? this.idPsicologo,
            nombre: nombre ?? this.nombre,
            horaInicioM: horaInicioM ?? this.horaInicioM,
            horaFinM: horaFinM ?? this.horaFinM,
            horaInicioT: horaInicioT ?? this.horaInicioT,
            horaFinT: horaFinT ?? this.horaFinT,
            estado: estado ?? this.estado,
        );
    }

    factory Horarios.fromJson(Map<String, dynamic> json){
        return Horarios(
            id: json["id"],
            idPsicologo: json["id_psicologo"],
            nombre: json["nombre"],
            horaInicioM: json["hora_inicio_m"],
            horaFinM: json["hora_fin_m"],
            horaInicioT: json["hora_inicio_t"],
            horaFinT: json["hora_fin_t"],
            estado: json["estado"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_psicologo": idPsicologo,
        "nombre": nombre,
        "hora_inicio_m": horaInicioM,
        "hora_fin_m": horaFinM,
        "hora_inicio_t": horaInicioT,
        "hora_fin_t": horaFinT,
        "estado": estado,
    };

    @override
    String toString(){
        return "$id, $idPsicologo, $nombre, $horaInicioM, $horaFinM, $horaInicioT, $horaFinT, $estado, ";
    }
}
