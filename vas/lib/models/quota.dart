class Quota {
  String id;
  String name;
  String remaining;
  int max;
  int? usableQuota;

  Quota({
    required this.id,
    required this.name,
    required this.remaining,
    required this.max,
    this.usableQuota,
  });

  factory Quota.fromJson(Map<String, dynamic> json) => Quota(
    id: json["id"],
    name: json["name"],
    remaining: json["remaining"],
    max: json["max"],
    usableQuota: json["usable_quota"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "remaining": remaining,
    "max": max,
    "usable_quota": usableQuota,
  };
}