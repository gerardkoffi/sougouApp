class OTPResponseModel {
  final String statusCode;
  final String codeText;
  final String message;
  final Map<String, dynamic> corps;

  OTPResponseModel({
    required this.statusCode,
    required this.codeText,
    required this.message,
    required this.corps,
  });

  factory OTPResponseModel.fromJson(Map<String, dynamic> json) {
    return OTPResponseModel(
      statusCode: json["statusCode"] ?? '',
      codeText: json["codeText"] ?? '',
      message: json["message"] ?? '',
      corps: json["corps"] ?? {},
    );
  }
}
