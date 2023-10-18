class Asistencia {
    Asistencia({
        required this.idAs,
        required this.fecha,
        required this.urlFoto,
    });

    final String? idAs;
    final DateTime? fecha;
    final String? urlFoto;

    Asistencia copyWith({
        String? idAs,
        DateTime? fecha,
        String? urlFoto,
    }) {
        return Asistencia(
            idAs: idAs ?? this.idAs,
            fecha: fecha ?? this.fecha,
            urlFoto: urlFoto ?? this.urlFoto,
        );
    }

    factory Asistencia.fromJson(Map<String, dynamic> json){
        return Asistencia(
            idAs: json["id_as"],
            fecha: DateTime.tryParse(json["fecha"] ?? ""),
            urlFoto: json["url_foto"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id_as": idAs,
        "fecha": fecha?.toIso8601String(),
        "url_foto": urlFoto,
    };

    @override
    String toString(){
        return "$idAs, $fecha, $urlFoto, ";
    }
}
