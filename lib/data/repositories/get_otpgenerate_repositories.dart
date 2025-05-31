import 'package:dio/dio.dart';
import '../../utils/api.dart';
import '../model/get_otpgenerate.dart';

class OTPRepository {
  Future<OTPResponseModel> generateOtp(String phoneNumber) async {

      final response = await ApiSougou.postapi(
        url: ApiSougou.getGenerateOtp,
        body: {"telephone": phoneNumber},
        useAuthToken: false,
      );

      if (response["statusCode"] == "200") {
        return OTPResponseModel.fromJson(response);
      } else {
        throw Exception(response["message"] ?? "Erreur inconnue");
      }
  }
}
