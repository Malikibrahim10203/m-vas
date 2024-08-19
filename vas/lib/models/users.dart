class User {
  int? userId;
  String? email;
  String? fullName;
  String? firstName;
  String? lastName;
  int? roleId;
  String? roleName;
  int? officeId;
  String? officeName;
  int? officeTypeId;
  String? officeTypeName;
  String? department;
  String? deptName;
  String? phone;
  int? status;
  bool? isDeleted;
  String? bcAddress;
  dynamic bcId;
  int? updatedBy;
  String? updatedByName;
  DateTime createdAt;
  DateTime updatedAt;
  bool? isFirst;
  bool? isActive;
  bool? isVerified;
  bool? isPic;
  bool? isContractActive;
  int? statusRegistrationPeruri;
  bool? isEmailPeruriSignVerified;
  int? statusVideoKyc;
  bool? isStatusVideoKyc;
  String? signatureId;
  String? parafId;
  dynamic? isSystemSign;
  String? signCertStatus;
  bool? portalPayment;
  bool? isRegistered;
  StorageCredential storageCredential;

  User({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.roleId,
    required this.roleName,
    required this.officeId,
    required this.officeName,
    required this.officeTypeId,
    required this.officeTypeName,
    required this.department,
    required this.deptName,
    required this.phone,
    required this.status,
    required this.isDeleted,
    required this.bcAddress,
    required this.bcId,
    required this.updatedBy,
    required this.updatedByName,
    required this.createdAt,
    required this.updatedAt,
    required this.isFirst,
    required this.isActive,
    required this.isVerified,
    required this.isPic,
    required this.isContractActive,
    required this.statusRegistrationPeruri,
    required this.isEmailPeruriSignVerified,
    required this.statusVideoKyc,
    required this.isStatusVideoKyc,
    required this.signatureId,
    required this.parafId,
    required this.isSystemSign,
    required this.signCertStatus,
    required this.portalPayment,
    required this.isRegistered,
    required this.storageCredential,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["user_id"],
    email: json["email"],
    fullName: json["full_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    roleId: json["role_id"],
    roleName: json["role_name"],
    officeId: json["office_id"],
    officeName: json["office_name"],
    officeTypeId: json["office_type_id"],
    officeTypeName: json["office_type_name"],
    department: json["department"],
    deptName: json["dept_name"],
    phone: json["phone"],
    status: json["status"],
    isDeleted: json["is_deleted"],
    bcAddress: json["bc_address"],
    bcId: json["bc_id"],
    updatedBy: json["updated_by"],
    updatedByName: json["updated_by_name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isFirst: json["is_first"],
    isActive: json["is_active"],
    isVerified: json["is_verified"],
    isPic: json["is_pic"],
    isContractActive: json["is_contract_active"],
    statusRegistrationPeruri: json["status_registration_peruri"],
    isEmailPeruriSignVerified: json["is_email_peruri_sign_verified"],
    statusVideoKyc: json["status_video_kyc"],
    isStatusVideoKyc: json["is_status_video_kyc"],
    signatureId: json["signature_id"],
    parafId: json["paraf_id"],
    isSystemSign: json["is_system_sign"],
    signCertStatus: json["sign_cert_status"],
    portalPayment: json["portal_payment"],
    isRegistered: json["is_registered"],
    storageCredential: StorageCredential.fromJson(json["storage_credential"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "email": email,
    "full_name": fullName,
    "first_name": firstName,
    "last_name": lastName,
    "role_id": roleId,
    "role_name": roleName,
    "office_id": officeId,
    "office_name": officeName,
    "office_type_id": officeTypeId,
    "office_type_name": officeTypeName,
    "department": department,
    "dept_name": deptName,
    "phone": phone,
    "status": status,
    "is_deleted": isDeleted,
    "bc_address": bcAddress,
    "bc_id": bcId,
    "updated_by": updatedBy,
    "updated_by_name": updatedByName,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "is_first": isFirst,
    "is_active": isActive,
    "is_verified": isVerified,
    "is_pic": isPic,
    "is_contract_active": isContractActive,
    "status_registration_peruri": statusRegistrationPeruri,
    "is_email_peruri_sign_verified": isEmailPeruriSignVerified,
    "status_video_kyc": statusVideoKyc,
    "is_status_video_kyc": isStatusVideoKyc,
    "signature_id": signatureId,
    "paraf_id": parafId,
    "is_system_sign": isSystemSign,
    "sign_cert_status": signCertStatus,
    "portal_payment": portalPayment,
    "is_registered": isRegistered,
    "storage_credential": storageCredential.toJson(),
  };
}

class StorageCredential {
  String? dirName;
  String? bypassOtp;
  String? sendEmailInvitation;
  String? sendTokenActivation;
  String? sendWaOtpActivation;
  String? sendEmailOtpActivation;

  StorageCredential({
    required this.dirName,
    required this.bypassOtp,
    required this.sendEmailInvitation,
    required this.sendTokenActivation,
    required this.sendWaOtpActivation,
    required this.sendEmailOtpActivation,
  });

  factory StorageCredential.fromJson(Map<String, dynamic> json) => StorageCredential(
    dirName: json["dir_name"],
    bypassOtp: json["bypass_otp"],
    sendEmailInvitation: json["send_email_invitation"],
    sendTokenActivation: json["send_token_activation"],
    sendWaOtpActivation: json["send_wa_otp_activation"],
    sendEmailOtpActivation: json["send_email_otp_activation"],
  );

  Map<String, dynamic> toJson() => {
    "dir_name": dirName,
    "bypass_otp": bypassOtp,
    "send_email_invitation": sendEmailInvitation,
    "send_token_activation": sendTokenActivation,
    "send_wa_otp_activation": sendWaOtpActivation,
    "send_email_otp_activation": sendEmailOtpActivation,
  };
}
