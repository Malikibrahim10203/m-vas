class Document {
  List<Datum> data;

  Document({
    required this.data,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String docId;
  String docName;
  int createdBy;
  List<DocumentElement>? documents;
  String originalName;
  String creator;
  bool isFolder;
  String stampActor;
  int stampStatus;
  bool isStamped;
  bool isSigned;
  bool isTera;
  bool signInProgress;
  bool teraInProgress;
  int officeId;
  String officeName;
  List<String?> tags;
  DateTime createdAt;
  String total;

  Datum({
    required this.docId,
    required this.docName,
    required this.createdBy,
    required this.documents,
    required this.originalName,
    required this.creator,
    required this.isFolder,
    required this.stampActor,
    required this.stampStatus,
    required this.isStamped,
    required this.isSigned,
    required this.isTera,
    required this.signInProgress,
    required this.teraInProgress,
    required this.officeId,
    required this.officeName,
    required this.tags,
    required this.createdAt,
    required this.total,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    docId: json["doc_id"],
    docName: json["doc_name"],
    createdBy: json["created_by"],
    documents: json["documents"] == null ? [] : List<DocumentElement>.from(json["documents"]!.map((x) => DocumentElement.fromJson(x))),
    originalName: json["original_name"],
    creator: json["creator"],
    isFolder: json["is_folder"],
    stampActor: json["stamp_actor"],
    stampStatus: json["stamp_status"],
    isStamped: json["is_stamped"],
    isSigned: json["is_signed"],
    isTera: json["is_tera"],
    signInProgress: json["sign_in_progress"],
    teraInProgress: json["tera_in_progress"],
    officeId: json["office_id"],
    officeName: json["office_name"],
    tags: List<String?>.from(json["tags"].map((x) => x)),
    createdAt: DateTime.parse(json["created_at"]),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "doc_id": docId,
    "doc_name": docName,
    "created_by": createdBy,
    "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x.toJson())),
    "original_name": originalName,
    "creator": creator,
    "is_folder": isFolder,
    "stamp_actor": stampActor,
    "stamp_status": stampStatus,
    "is_stamped": isStamped,
    "is_signed": isSigned,
    "is_tera": isTera,
    "sign_in_progress": signInProgress,
    "tera_in_progress": teraInProgress,
    "office_id": officeId,
    "office_name": officeName,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "created_at": createdAt.toIso8601String(),
    "total": total,
  };
}

class DocumentElement {
  String date;
  int docId;
  String docName;
  int createdBy;
  int updatedBy;
  String description;
  String originalName;

  DocumentElement({
    required this.date,
    required this.docId,
    required this.docName,
    required this.createdBy,
    required this.updatedBy,
    required this.description,
    required this.originalName,
  });

  factory DocumentElement.fromJson(Map<String, dynamic> json) => DocumentElement(
    date: json["date"],
    docId: json["doc_id"],
    docName: json["doc_name"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    description: json["description"],
    originalName: json["original_name"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "doc_id": docId,
    "doc_name": docName,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "description": description,
    "original_name": originalName,
  };
}