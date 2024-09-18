class ListTypeDocument {
  String id;
  String kode;
  String nama;

  ListTypeDocument({
    required this.id,
    required this.kode,
    required this.nama,
  });

  factory ListTypeDocument.fromJson(Map<String, dynamic> json) => ListTypeDocument(
    id: json["id"],
    kode: json["kode"],
    nama: json["nama"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kode": kode,
    "nama": nama,
  };
}