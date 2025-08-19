import 'dart:convert';

class FileInfo {
  final String file;

  FileInfo({required this.file});

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      file: json['file'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file,
    };
  }

  @override
  String toString() {
    return 'FileInfo(file: $file)';
  }
}

// Fonctions de conversion JSON <-> FileInfo

FileInfo fileInfoFromJson(String str) => FileInfo.fromJson(json.decode(str));

String fileInfoToJson(FileInfo data) => json.encode(data.toJson());
