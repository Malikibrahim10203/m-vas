class Api {
  static const _host = "https://bedmsdemo.vas.id";

  static String login = "$_host/api/v1/login";
  static String forget_password = "https://appbedmsdemo.vas.id/api/v1/forgot";
  static String change_password = "$_host/api/v1/forgot";

  static String get_user = "$_host/api/v1/user/profile";
  static String check_certificate = "$_host/api/v1/sign/checkCertificate";
  static String check_quota = "$_host/api/v1/quota";

  static String get_module = "$_host/api/v1/module";
  static String regist_peruri = "$_host/api/v1/sign/register";

  static String get_region = "$_host/api/v1/region";
  static String get_peruri_jwt_token = "$_host/api/v1/sign/token";

}