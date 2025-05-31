import 'dart:convert';

DeleteModel deleteProductFromJson(String str) => DeleteModel.fromJson(json.decode(str));

String deleteProductToJson(DeleteModel data) => json.encode(data.toJson());

class DeleteModel<T> {
  final String statusCode;
  final String codeText;
  final String message;
  final Map<String, dynamic> corps;

  DeleteModel({
    required this.statusCode,
    required this.codeText,
    required this.message,
    required this.corps,
  });

  factory DeleteModel.fromJson(Map<String, dynamic> json) {
    return DeleteModel(
      statusCode: json["statusCode"] ?? '',
      codeText: json["codeText"] ?? '',
      message: json["message"] ?? '',
      corps: json["corps"] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "statusCode": statusCode,
      "codeText": codeText,
      "message": message,
      "corps": corps,
    };
  }
}
