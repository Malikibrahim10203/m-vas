class Bulkdocument {
  dynamic? versionFrom;
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
    docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
    receipts: List<dynamic>.from(json["receipts"].map((x) => x)),
    tags: List<dynamic>.from(json["tags"].map((x) => x)),
    versions: List<Version>.from(json["versions"].map((x) => Version.fromJson(x))),
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
    "docs": List<dynamic>.from(docs!.map((x) => x.toJson())),
    "receipts": List<dynamic>.from(receipts!.map((x) => x)),
    "tags": List<dynamic>.from(tags!.map((x) => x)),
    "versions": List<dynamic>.from(versions!.map((x) => x.toJson())),
    "is_authentic": isAuthentic,
    "total_docs": totalDocs,
  };
}

class Doc {
  int? docId;
  String? docName;
  String? date;
  String? bcAddress;
  String? file;
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
    docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "version": version,
    "stamp_status": stampStatus,
    "docs": List<dynamic>.from(docs!.map((x) => x.toJson())),
  };
}
