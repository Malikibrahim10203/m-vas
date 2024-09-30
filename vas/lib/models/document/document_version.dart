class DocumentVersion {
  List<Version> versions;

  DocumentVersion({
    required this.versions,
  });

  factory DocumentVersion.fromJson(Map<String, dynamic> json) => DocumentVersion(
    versions: List<Version>.from(json["versions"].map((x) => Version.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "versions": List<dynamic>.from(versions.map((x) => x.toJson())),
  };
}

class Version {
  int docId;
  String docName;
  String file;
  String description;
  int officeId;
  dynamic bcAddress;
  DateTime date;
  int createdBy;
  int updatedBy;
  String creator;
  DateTime createdAt;
  DateTime updatedAt;
  int version;
  String versionFrom;
  int stampStatus;

  Version({
    required this.docId,
    required this.docName,
    required this.file,
    required this.description,
    required this.officeId,
    required this.bcAddress,
    required this.date,
    required this.createdBy,
    required this.updatedBy,
    required this.creator,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.versionFrom,
    required this.stampStatus,
  });

  factory Version.fromJson(Map<String, dynamic> json) => Version(
    docId: json["doc_id"],
    docName: json["doc_name"],
    file: json["file"],
    description: json["description"],
    officeId: json["office_id"],
    bcAddress: json["bc_address"],
    date: DateTime.parse(json["date"]),
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    creator: json["creator"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    version: json["version"],
    versionFrom: json["version_from"],
    stampStatus: json["stamp_status"],
  );

  Map<String, dynamic> toJson() => {
    "doc_id": docId,
    "doc_name": docName,
    "file": file,
    "description": description,
    "office_id": officeId,
    "bc_address": bcAddress,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "created_by": createdBy,
    "updated_by": updatedBy,
    "creator": creator,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "version": version,
    "version_from": versionFrom,
    "stamp_status": stampStatus,
  };
}
