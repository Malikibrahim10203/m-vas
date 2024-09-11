class Activity {
  List<ActivityElement> data;

  Activity({
    required this.data,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    data: List<ActivityElement>.from(json["data"].map((x) => ActivityElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ActivityElement {
  String? total;
  int? docLogId;
  String? activity;
  int? docId;
  String? browser;
  String? deviceType;
  String? os;
  String? ip;
  dynamic? page;
  dynamic? note;
  int? createdBy;
  DateTime? createdAt;
  String? productId;
  int? productAmount;
  String? creator;
  String? docName;
  int? version;

  ActivityElement({
    required this.total,
    required this.docLogId,
    required this.activity,
    required this.docId,
    required this.browser,
    required this.deviceType,
    required this.os,
    required this.ip,
    required this.page,
    required this.note,
    required this.createdBy,
    required this.createdAt,
    required this.productId,
    required this.productAmount,
    required this.creator,
    required this.docName,
    required this.version,
  });

  factory ActivityElement.fromJson(Map<String, dynamic> json) => ActivityElement(
    total: json["total"],
    docLogId: json["doc_log_id"],
    activity: json["activity"],
    docId: json["doc_id"],
    browser: json["browser"],
    deviceType: json["device_type"],
    os: json["os"],
    ip: json["ip"],
    page: json["page"],
    note: json["note"],
    createdBy: json["created_by"],
    createdAt: DateTime.parse(json["created_at"]),
    productId: json["product_id"],
    productAmount: json["product_amount"],
    creator: json["creator"],
    docName: json["doc_name"],
    version: json["version"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "doc_log_id": docLogId,
    "activity": activity,
    "doc_id": docId,
    "browser": browser,
    "device_type": deviceType,
    "os": os,
    "ip": ip,
    "page": page,
    "note": note,
    "created_by": createdBy,
    "created_at": createdAt!.toIso8601String(),
    "product_id": productId,
    "product_amount": productAmount,
    "creator": creator,
    "doc_name": docName,
    "version": version,
  };
}
