class Bulkdocument {
  String? versionFrom;
  String? id;
  String? name;
  String? description;
  DateTime createdAt;
  String? officeName;
  String? creator;
  String? email;
  int? version;
  List<Doc>? docs;
  List<dynamic>? receipts;
  List<dynamic>? tags;
  StampInProgress? stampInProgress;
  List<Version>? versions;
  bool? isAuthentic;
  String? totalDocs;

  Bulkdocument({
    required this.versionFrom,
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.officeName,
    required this.creator,
    required this.email,
    required this.version,
    required this.docs,
    required this.receipts,
    required this.tags,
    required this.stampInProgress,
    required this.versions,
    required this.isAuthentic,
    required this.totalDocs,
  });

  factory Bulkdocument.fromJson(Map<String, dynamic> json) => Bulkdocument(
    versionFrom: json["version_from"],
    id: json["id"],
    name: json["name"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    officeName: json["office_name"],
    creator: json["creator"],
    email: json["email"],
    version: json["version"],
    docs: json["docs"] != null ? List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))) : null,
    receipts: json["receipts"] != null ? List<dynamic>.from(json["receipts"].map((x) => x)) : null,
    tags: json["tags"] != null ? List<dynamic>.from(json["tags"].map((x) => x)) : null,
    stampInProgress: json["stamp_in_progress"] != null ? StampInProgress.fromJson(json["stamp_in_progress"]) : null,
    versions: json["versions"] != null ? List<Version>.from(json["versions"].map((x) => Version.fromJson(x))) : null,
    isAuthentic: json["is_authentic"],
    totalDocs: json["total_docs"],
  );

  Map<String, dynamic> toJson() => {
    "version_from": versionFrom,
    "id": id,
    "name": name,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "office_name": officeName,
    "creator": creator,
    "email": email,
    "version": version,
    "docs": docs != null ? List<dynamic>.from(docs!.map((x) => x.toJson())) : null,
    "receipts": receipts != null ? List<dynamic>.from(receipts!) : null,
    "tags": tags != null ? List<dynamic>.from(tags!) : null,
    "stamp_in_progress": stampInProgress?.toJson(),
    "versions": versions != null ? List<dynamic>.from(versions!.map((x) => x.toJson())) : null,
    "is_authentic": isAuthentic,
    "total_docs": totalDocs,
  };
}

class Doc {
  int docId;
  String docName;
  String date;
  dynamic bcAddress;
  String file;
  String? description;

  Doc({
    required this.docId,
    required this.docName,
    required this.date,
    required this.bcAddress,
    required this.file,
    this.description,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
    docId: json["doc_id"],
    docName: json["doc_name"],
    date: json["date"],
    bcAddress: json["bc_address"],
    file: json["file"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "doc_id": docId,
    "doc_name": docName,
    "date": date,
    "bc_address": bcAddress,
    "file": file,
    "description": description,
  };
}

class StampInProgress {
  String id;
  DateTime createdAt;
  int version;
  String versionFrom;
  int stampStatus;
  String stampedDocs;
  String failedDocs;

  StampInProgress({
    required this.id,
    required this.createdAt,
    required this.version,
    required this.versionFrom,
    required this.stampStatus,
    required this.stampedDocs,
    required this.failedDocs,
  });

  factory StampInProgress.fromJson(Map<String, dynamic> json) => StampInProgress(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    version: json["version"],
    versionFrom: json["version_from"],
    stampStatus: json["stamp_status"],
    stampedDocs: json["stamped_docs"],
    failedDocs: json["failed_docs"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "version": version,
    "version_from": versionFrom,
    "stamp_status": stampStatus,
    "stamped_docs": stampedDocs,
    "failed_docs": failedDocs,
  };
}

class Version {
  String? id;
  String? name;
  String? description;
  DateTime createdAt;
  int? version;
  int? stampStatus;
  List<Doc>? docs;

  Version({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.version,
    required this.stampStatus,
    required this.docs,
  });

  factory Version.fromJson(Map<String, dynamic> json) => Version(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    version: json["version"],
    stampStatus: json["stamp_status"],
    docs: json["docs"] != null ? List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "version": version,
    "stamp_status": stampStatus,
    "docs": docs != null ? List<dynamic>.from(docs!.map((x) => x.toJson())) : null,
  };
}
