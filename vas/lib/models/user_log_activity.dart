class UserLogActivity {
  List<DataLogActivity> data;

  UserLogActivity({
    required this.data,
  });

  factory UserLogActivity.fromJson(Map<String, dynamic> json) => UserLogActivity(
    data: List<DataLogActivity>.from(json["data"].map((x) => DataLogActivity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "DataLogActivity": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataLogActivity {
  int userLogId;
  String activity;
  dynamic notes;
  String browser;
  String deviceType;
  String os;
  String ip;
  int createdBy;
  DateTime createdAt;
  dynamic productId;
  dynamic productAmount;
  String creator;
  String department;
  int officeId;
  dynamic branchFrom;
  String total;

  DataLogActivity({
    required this.userLogId,
    required this.activity,
    required this.notes,
    required this.browser,
    required this.deviceType,
    required this.os,
    required this.ip,
    required this.createdBy,
    required this.createdAt,
    required this.productId,
    required this.productAmount,
    required this.creator,
    required this.department,
    required this.officeId,
    required this.branchFrom,
    required this.total,
  });

  factory DataLogActivity.fromJson(Map<String, dynamic> json) => DataLogActivity(
    userLogId: json["user_log_id"],
    activity: json["activity"],
    notes: json["notes"],
    browser: json["browser"],
    deviceType: json["device_type"],
    os: json["os"],
    ip: json["ip"],
    createdBy: json["created_by"],
    createdAt: DateTime.parse(json["created_at"]),
    productId: json["product_id"],
    productAmount: json["product_amount"],
    creator: json["creator"],
    department: json["department"],
    officeId: json["office_id"],
    branchFrom: json["branch_from"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "user_log_id": userLogId,
    "activity": activity,
    "notes": notes,
    "browser": browser,
    "device_type": deviceType,
    "os": os,
    "ip": ip,
    "created_by": createdBy,
    "created_at": createdAt.toIso8601String(),
    "product_id": productId,
    "product_amount": productAmount,
    "creator": creator,
    "department": department,
    "office_id": officeId,
    "branch_from": branchFrom,
    "total": total,
  };
}
