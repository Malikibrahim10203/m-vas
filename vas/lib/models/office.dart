class Office {
  int officeId;
  int officeTypeId;
  String officeName;
  String? email;
  String? phone;
  bool isVerified;
  bool isActive;
  int createdBy;
  DateTime createdAt;
  int? branchFrom;
  String? peruriPass;
  String storageType;
  StorageCredential storageCredential;
  dynamic bcAddress;
  String? peruriToken;
  String? peruriId;
  String peruriEsignToken;
  DateTime esignTokenExpiredate;
  String? peruriEsignSystemid;
  String onpremStorageToken;
  DateTime onpremStorageTokenExpireddate;
  bool portalPayment;
  String officeTypeName;
  int picId;
  String picFullName;
  String total;

  Office({
    required this.officeId,
    required this.officeTypeId,
    required this.officeName,
    required this.email,
    required this.phone,
    required this.isVerified,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.branchFrom,
    required this.peruriPass,
    required this.storageType,
    required this.storageCredential,
    required this.bcAddress,
    required this.peruriToken,
    required this.peruriId,
    required this.peruriEsignToken,
    required this.esignTokenExpiredate,
    required this.peruriEsignSystemid,
    required this.onpremStorageToken,
    required this.onpremStorageTokenExpireddate,
    required this.portalPayment,
    required this.officeTypeName,
    required this.picId,
    required this.picFullName,
    required this.total,
  });

  factory Office.fromJson(Map<String, dynamic> json) => Office(
    officeId: json["office_id"],
    officeTypeId: json["office_type_id"],
    officeName: json["office_name"],
    email: json["email"],
    phone: json["phone"],
    isVerified: json["is_verified"],
    isActive: json["is_active"],
    createdBy: json["created_by"],
    createdAt: DateTime.parse(json["created_at"]),
    branchFrom: json["branch_from"],
    peruriPass: json["peruri_pass"],
    storageType: json["storage_type"],
    storageCredential: StorageCredential.fromJson(json["storage_credential"]),
    bcAddress: json["bc_address"],
    peruriToken: json["peruri_token"],
    peruriId: json["peruri_id"],
    peruriEsignToken: json["peruri_esign_token"],
    esignTokenExpiredate: DateTime.parse(json["esign_token_expiredate"]),
    peruriEsignSystemid: json["peruri_esign_systemid"],
    onpremStorageToken: json["onprem_storage_token"],
    onpremStorageTokenExpireddate: DateTime.parse(json["onprem_storage_token_expireddate"]),
    portalPayment: json["portal_payment"],
    officeTypeName: json["office_type_name"],
    picId: json["pic_id"],
    picFullName: json["pic_full_name"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "office_id": officeId,
    "office_type_id": officeTypeId,
    "office_name": officeName,
    "email": email,
    "phone": phone,
    "is_verified": isVerified,
    "is_active": isActive,
    "created_by": createdBy,
    "created_at": createdAt.toIso8601String(),
    "branch_from": branchFrom,
    "peruri_pass": peruriPass,
    "storage_type": storageType,
    "storage_credential": storageCredential.toJson(),
    "bc_address": bcAddress,
    "peruri_token": peruriToken,
    "peruri_id": peruriId,
    "peruri_esign_token": peruriEsignToken,
    "esign_token_expiredate": esignTokenExpiredate.toIso8601String(),
    "peruri_esign_systemid": peruriEsignSystemid,
    "onprem_storage_token": onpremStorageToken,
    "onprem_storage_token_expireddate": onpremStorageTokenExpireddate.toIso8601String(),
    "portal_payment": portalPayment,
    "office_type_name": officeTypeName,
    "pic_id": picId,
    "pic_full_name": picFullName,
    "total": total,
  };
}

class StorageCredential {
  String dirName;
  String? bypassOtp;
  String sendEmailInvitation;
  String sendTokenActivation;
  String sendWaOtpActivation;
  String sendEmailOtpActivation;
  String? exclusiveTreatment;

  StorageCredential({
    required this.dirName,
    this.bypassOtp,
    required this.sendEmailInvitation,
    required this.sendTokenActivation,
    required this.sendWaOtpActivation,
    required this.sendEmailOtpActivation,
    this.exclusiveTreatment,
  });

  factory StorageCredential.fromJson(Map<String, dynamic> json) => StorageCredential(
    dirName: json["dir_name"],
    bypassOtp: json["bypass_otp"],
    sendEmailInvitation: json["send_email_invitation"],
    sendTokenActivation: json["send_token_activation"],
    sendWaOtpActivation: json["send_wa_otp_activation"],
    sendEmailOtpActivation: json["send_email_otp_activation"],
    exclusiveTreatment: json["exclusive_treatment"],
  );

  Map<String, dynamic> toJson() => {
    "dir_name": dirName,
    "bypass_otp": bypassOtp,
    "send_email_invitation": sendEmailInvitation,
    "send_token_activation": sendTokenActivation,
    "send_wa_otp_activation": sendWaOtpActivation,
    "send_email_otp_activation": sendEmailOtpActivation,
    "exclusive_treatment": exclusiveTreatment,
  };
}