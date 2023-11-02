class Especialidad {
    Especialidad({
        required this.id,
        required this.nombre,
    });

    final int? id;
    final String? nombre;

    Especialidad copyWith({
        int? id,
        String? nombre,
    }) {
        return Especialidad(
            id: id ?? this.id,
            nombre: nombre ?? this.nombre,
        );
    }

    factory Especialidad.fromJson(Map<String, dynamic> json){
        return Especialidad(
            id: json["id"],
            nombre: json["nombre"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };

    @override
    String toString(){
        return "$id, $nombre, ";
    }
}
