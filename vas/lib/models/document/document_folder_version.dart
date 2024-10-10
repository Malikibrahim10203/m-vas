class DocumentFolderVersion {
  List<DocumentFolderVersionElement> documentFolderVersion;

  DocumentFolderVersion({
    required this.documentFolderVersion,
  });

  factory DocumentFolderVersion.fromJson(Map<String, dynamic> json) => DocumentFolderVersion(
    documentFolderVersion: List<DocumentFolderVersionElement>.from(json["document_folder_version"].map((x) => DocumentFolderVersionElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "document_folder_version": List<dynamic>.from(documentFolderVersion.map((x) => x.toJson())),
  };
}

class DocumentFolderVersionElement {
  String id;
  String name;
  String description;
  int uploadedBy;
  DateTime createdAt;
  int version;
  String? versionFrom;
  List<Doc> docs;

  DocumentFolderVersionElement({
    required this.id,
    required this.name,
    required this.description,
    required this.uploadedBy,
    required this.createdAt,
    required this.version,
    required this.versionFrom,
    required this.docs,
  });

  factory DocumentFolderVersionElement.fromJson(Map<String, dynamic> json) => DocumentFolderVersionElement(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    uploadedBy: json["uploaded_by"],
    createdAt: DateTime.parse(json["created_at"]),
    version: json["version"],
    versionFrom: json["version_from"],
    docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "uploaded_by": uploadedBy,
    "created_at": createdAt.toIso8601String(),
    "version": version,
    "version_from": versionFrom,
    "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
  };
}

class Doc {
  int docId;
  String docName;
  String description;
  String date;
  DateTime createdAt;
  DateTime updatedAt;
  int version;
  int? versionFrom;
  String originalName;

  Doc({
    required this.docId,
    required this.docName,
    required this.description,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.versionFrom,
    required this.originalName,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
    docId: json["doc_id"],
    docName: json["doc_name"],
    description: json["description"],
    date: json["date"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    version: json["version"],
    versionFrom: json["version_from"],
    originalName: json["original_name"],
  );

  Map<String, dynamic> toJson() => {
    "doc_id": docId,
    "doc_name": docName,
    "description": description,
    "date": date,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "version": version,
    "version_from": versionFrom,
    "original_name": originalName,
  };
}