class Province {
  int provinceId;
  String provinceName;

  Province({
    required this.provinceId,
    required this.provinceName,
  });

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    provinceId: json["province_id"],
    provinceName: json["province_name"],
  );

  Map<String, dynamic> toJson() => {
    "province_id": provinceId,
    "province_name": provinceName,
  };
}
