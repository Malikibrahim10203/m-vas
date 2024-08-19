class Credential {
  String? email;
  String? password;
  Data data;

  Credential({
    required this.email,
    required this.password,
    required this.data,
  });

  factory Credential.fromJson(Map<String, dynamic> json) => Credential(
    email: json["email"],
    password: json["password"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "data": data.toJson(),
  };
}

class Data {
  int? roleId;
  String? token;

  Data({
    required this.roleId,
    required this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    roleId: json["role_id"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "role_id": roleId,
    "token": token,
  };
}
