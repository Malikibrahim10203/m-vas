class Api {
  static const _host = "https://bedmsdemo.vas.id";

  static String login = "$_host/api/v1/login";
  static String forget_password = "$_host/api/v1/forgot";
  static String change_password = "$_host/api/v1/forgot";

  static String get_user = "$_host/api/v1/user/profile";
  static String check_certificate = "$_host/api/v1/sign/checkCertificate";
  static String check_quota = "$_host/api/v1/quota";

  static String get_module = "$_host/api/v1/module";
  static String regist_peruri = "$_host/api/v1/sign/register";

  static String get_region = "$_host/api/v1/region";
  static String get_peruri_jwt_token = "$_host/api/v1/sign/token";

  // dropdown department && office
  static String get_department = "$_host/api/v1/dept-dropdown";
  static String get_office = "$_host/api/v1/office";


  // eKyc
  static String activate_email = "$_host/api/v1/sign/activate-email";
  static String resend_activate_email = "$_host/api/v1/sign/resend-activation";

  static String send_otp = "$_host/api/v1/sign/send-otp";
  static String check_otp = "$_host/api/v1/sign/check-otp";

  static String regist_video_kyc = "$_host/api/v1/sign/video-kyc";


  // Upload Document
  static String upload_single = "$_host/api/v1/document";
  static String upload_bulk = "$_host/api/v1/document-bulk";

  // Get All Document
  static String get_all_document = "$_host/api/v1/document";

  // Get One Document
  static String get_one_document = "$_host/api/v1/document/";

  // Get Document Activity
  static String get_document_activity = "$_host/api/v1/document-log-activities";

  // Get Log Activity
  static String get_log_activity = "$_host/api/v1/user-log-activities";


  // Get Document Type for Stamping
  static String get_document_types = "$_host/api/v1/peruri/list-doc";

}