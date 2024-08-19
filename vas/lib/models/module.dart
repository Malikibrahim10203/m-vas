class ModuleData {
  int? officeId;
  bool? documentM;
  bool? userM;
  dynamic? groupM;
  bool? officeM;
  bool? stampM;
  dynamic? signM;
  dynamic? backupM;
  bool? blockchainM;

  ModuleData({
    required this.officeId,
    required this.documentM,
    required this.userM,
    required this.groupM,
    required this.officeM,
    required this.stampM,
    required this.signM,
    required this.backupM,
    required this.blockchainM,
  });

  factory ModuleData.fromJson(Map<String, dynamic> json) => ModuleData(
    officeId: json["office_id"],
    documentM: json["document_m"],
    userM: json["user_m"],
    groupM: json["group_m"],
    officeM: json["office_m"],
    stampM: json["stamp_m"],
    signM: json["sign_m"],
    backupM: json["backup_m"],
    blockchainM: json["blockchain_m"],
  );

  Map<String, dynamic> toJson() => {
    "office_id": officeId,
    "document_m": documentM,
    "user_m": userM,
    "group_m": groupM,
    "office_m": officeM,
    "stamp_m": stampM,
    "sign_m": signM,
    "backup_m": backupM,
    "blockchain_m": blockchainM,
  };
}
