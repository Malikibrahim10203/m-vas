class PeruriJwtToken {
  String? tokenPeruriSign;
  DateTime expireAt;

  PeruriJwtToken({
    required this.tokenPeruriSign,
    required this.expireAt,
  });

  factory PeruriJwtToken.fromJson(Map<String, dynamic> json) => PeruriJwtToken(
    tokenPeruriSign: json["token_peruri_sign"],
    expireAt: DateTime.parse(json["expire_at"]),
  );

  Map<String, dynamic> toJson() => {
    "token_peruri_sign": tokenPeruriSign,
    "expire_at": expireAt.toIso8601String(),
  };
}