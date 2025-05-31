import 'package:dio/dio.dart';
import '../../utils/api.dart';
import '../model/get_otpgenerate.dart';

class VerifyOtpRepositories {
  Future<OTPResponseModel> verifyOtp(String phoneNumber, String otpCode) async {

    final response = await ApiSougou.getapi(
      url: ApiSougou.getVerifyOtp,
      queryParameters: {"telephone": phoneNumber, "otp":otpCode},
      useAuthToken: false,
    );

    if (response["statusCode"] == "200") {
      return OTPResponseModel.fromJson(response);
    } else {
      throw Exception(response["message"] ?? "Erreur inconnue");
    }
  }
}
