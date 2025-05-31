import 'dart:convert';

CommonResponse commonResponseFromJson(String str) => CommonResponse.fromJson(json.decode(str));

String commonResponseToJson(CommonResponse data) => json.encode(data.toJson());

class CommonResponse {
  final String statusCode;
  final String codeText;
  final String message;
  final dynamic corps; // peut être Map, List, ou null

  CommonResponse({
    required this.statusCode,
    required this.codeText,
    required this.message,
    required this.corps,
  });

  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(
      statusCode: json['statusCode'] ?? '',
      codeText: json['codeText'] ?? '',
      message: json['message'] ?? '',
      corps: json['corps'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'codeText': codeText,
      'message': message,
      'corps': corps,
    };
  }
}
