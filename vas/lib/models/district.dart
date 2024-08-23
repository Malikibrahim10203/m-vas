class District {
  int kabId;
  String kabName;

  District({
    required this.kabId,
    required this.kabName,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
    kabId: json["kab_id"],
    kabName: json["kab_name"],
  );

  Map<String, dynamic> toJson() => {
    "kab_id": kabId,
    "kab_name": kabName,
  };
}
