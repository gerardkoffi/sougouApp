/*import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/model/get_otpgenerate.dart';
import '../data/repositories/get_otpgenerate_repositories.dart';
import '../data/repositories/verify_otp_repositories.dart';

/// 📌 Définition des états
abstract class OTPState {}

class OTPStateInit extends OTPState {}

class OTPStateInProgress extends OTPState {}

class OTPStateSuccess extends OTPState {
  final OTPResponseModel otpResponse;
  OTPStateSuccess({required this.otpResponse});
}



class OTPStateError extends OTPState {
  final String error;
  OTPStateError({required this.error});
}

/// 📌 Définition du Cubit
class OTPCubit extends Cubit<OTPState> {
  final OTPRepository otpRepository;
  final VerifyOtpRepositories verifyOtpRepository;

  OTPCubit({required this.otpRepository,required this.verifyOtpRepository}) : super(OTPStateInit());

  /// 🔹 Fonction pour générer l’OTP
  Future<void> generateOtp(String phoneNumber) async {
    emit(OTPStateInProgress());
    try {
      final response = await otpRepository.generateOtp(phoneNumber);
      emit(OTPStateSuccess(otpResponse: response));
    } catch (e) {
      emit(OTPStateError(error: e.toString()));
    }
  }
 /// 🔹 Fonction pour verifier l’OTP
  Future<void> verifyOtp(String phoneNumber, String otpCode) async {
    emit(OTPStateInProgress());
    try {
      final response = await verifyOtpRepository.verifyOtp(phoneNumber,otpCode);
      emit(OTPStateSuccess(otpResponse: response));
    } catch (e) {
      emit(OTPStateError(error: e.toString()));
    }
  }

  /// 🔹 Vérifie si le code OTP est bien reçu
  bool isOtpReceived() {
    if (state is OTPStateSuccess) {
      return (state as OTPStateSuccess).otpResponse.codeText.isNotEmpty;
    }
    return false;
  }
}*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/get_otpgenerate.dart';
import '../data/repositories/get_otpgenerate_repositories.dart';
import '../data/repositories/verify_otp_repositories.dart';

/// 📌 Définition des états
abstract class OTPState {}

class OTPStateInit extends OTPState {}

class OTPStateInProgress extends OTPState {}

class OTPGenerateSuccess extends OTPState {
  final OTPResponseModel otpResponse;
  OTPGenerateSuccess({required this.otpResponse});
}

class OTPVerifySuccess extends OTPState {
  final OTPResponseModel otpResponse;
  OTPVerifySuccess({required this.otpResponse});
}

class OTPStateError extends OTPState {
  final String error;
  OTPStateError({required this.error});
}

/// 📌 Définition du Cubit
class OTPCubit extends Cubit<OTPState> {
  final OTPRepository otpRepository;
  final VerifyOtpRepositories verifyOtpRepository;

  OTPCubit({required this.otpRepository, required this.verifyOtpRepository}) : super(OTPStateInit());

  /// 🔹 Fonction pour générer l’OTP
  Future<void> generateOtp(String phoneNumber) async {
    emit(OTPStateInProgress());
    try {
      final response = await otpRepository.generateOtp(phoneNumber);

      // Sauvegarde du numéro de téléphone
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phoneNumber', phoneNumber);

      emit(OTPGenerateSuccess(otpResponse: response));
    } catch (e) {
      emit(OTPStateError(error: e.toString()));
    }
  }

  /// 🔹 Fonction pour vérifier l’OTP
  Future<void> verifyOtp(String phoneNumber, String otpCode) async {
    emit(OTPStateInProgress());
    try {
      final response = await verifyOtpRepository.verifyOtp(phoneNumber, otpCode);

      if (response.codeText == "OTP_VALID") {
        emit(OTPVerifySuccess(otpResponse: response));
      } else {
        emit(OTPStateError(error: "Code OTP incorrect, veuillez réessayer."));
      }
    } catch (e) {
      emit(OTPStateError(error: e.toString()));
    }
  }

  /// 🔹 Vérifie si l’OTP a été reçu
  bool isOtpReceived() {
    return state is OTPGenerateSuccess || state is OTPVerifySuccess;
  }
}