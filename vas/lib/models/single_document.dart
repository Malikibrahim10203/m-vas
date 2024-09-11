class Singledocument {
  dynamic? versionFrom;
  int? docId;
  int? id;
  String? docName;
  DateTime date;
  dynamic? docCode;
  dynamic? docCatName;
  String? description;
  int? officeId;
  String? file;
  String? file2;
  String? officeName;
  dynamic? bcAddress;
  int? createdBy;
  String? creator;
  DateTime? createdAt;
  String? updater;
  DateTime? updatedAt;
  String? roleName;
  dynamic? signerId;
  int? version;
  List<dynamic> tags;
  List<dynamic> versions;
  bool? isAuthentic;
  List<dynamic> receipts;
  StampInProgress stampInProgress;

  Singledocument({
    required this.versionFrom,
    required this.docId,
    required this.id,
    required this.docName,
    required this.date,
    required this.docCode,
    required this.docCatName,
    required this.description,
    required this.officeId,
    required this.file,
    required this.file2,
    required this.officeName,
    required this.bcAddress,
    required this.createdBy,
    required this.creator,
    required this.createdAt,
    required this.updater,
    required this.updatedAt,
    required this.roleName,
    required this.signerId,
    required this.version,
    required this.tags,
    required this.versions,
    required this.isAuthentic,
    required this.receipts,
    required this.stampInProgress,
  });

  factory Singledocument.fromJson(Map<String, dynamic> json) => Singledocument(
    versionFrom: json["version_from"],
    docId: json["doc_id"],
    id: json["id"],
    docName: json["doc_name"],
    date: DateTime.parse(json["date"]),
    docCode: json["doc_code"],
    docCatName: json["doc_cat_name"],
    description: json["description"],
    officeId: json["office_id"],
    file: json["file"],
    file2: json["file2"],
    officeName: json["office_name"],
    bcAddress: json["bc_address"],
    createdBy: json["created_by"],
    creator: json["creator"],
    createdAt: DateTime.parse(json["created_at"]),
    updater: json["updater"],
    updatedAt: DateTime.parse(json["updated_at"]),
    roleName: json["role_name"],
    signerId: json["signer_id"],
    version: json["version"],
    tags: List<dynamic>.from(json["tags"].map((x) => x)),
    versions: List<dynamic>.from(json["versions"].map((x) => x)),
    isAuthentic: json["is_authentic"],
    receipts: List<dynamic>.from(json["receipts"].map((x) => x)),
    stampInProgress: StampInProgress.fromJson(json["stamp_in_progress"]),
  );

  Map<String, dynamic> toJson() => {
    "version_from": versionFrom,
    "doc_id": docId,
    "id": id,
    "doc_name": docName,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "doc_code": docCode,
    "doc_cat_name": docCatName,
    "description": description,
    "office_id": officeId,
    "file": file,
    "file2": file2,
    "office_name": officeName,
    "bc_address": bcAddress,
    "created_by": createdBy,
    "creator": creator,
    "created_at": createdAt!.toIso8601String(),
    "updater": updater,
    "updated_at": updatedAt!.toIso8601String(),
    "role_name": roleName,
    "signer_id": signerId,
    "version": version,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "versions": List<dynamic>.from(versions.map((x) => x)),
    "is_authentic": isAuthentic,
    "receipts": List<dynamic>.from(receipts.map((x) => x)),
    "stamp_in_progress": stampInProgress.toJson(),
  };
}

class StampInProgress {
  int? id;
  int? stampStatus;
  DateTime createdAt;

  StampInProgress({
    required this.id,
    required this.stampStatus,
    required this.createdAt,
  });

  factory StampInProgress.fromJson(Map<String, dynamic> json) => StampInProgress(
    id: json["id"],
    stampStatus: json["stamp_status"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "stamp_status": stampStatus,
    "created_at": createdAt.toIso8601String(),
  };
}
