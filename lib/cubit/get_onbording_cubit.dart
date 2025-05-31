// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sougou_app/data/model/get_onbording_model.dart';
import 'package:sougou_app/data/repositories/get_onbording_repositories.dart';

abstract class GetOnbordingState {}

class GetOnbordingStateInit extends GetOnbordingState {}

class GetOnbordingStateInProgress extends GetOnbordingState {}

class GetOnbordingStateInSussess extends GetOnbordingState {
  final bool useAuthtoken;
  final List<GetOnboardingList> onbordingdata;
  GetOnbordingStateInSussess(
      {required this.onbordingdata, required this.useAuthtoken});
}

class GetOnbordingInError extends GetOnbordingState {
  String error;
  GetOnbordingInError({
    required this.error,
  });
}

class GetOnbordingCubit extends Cubit<GetOnbordingState> {
  GetOnbordingCubit() : super(GetOnbordingStateInit());

  Future getOnbording() async {
    emit(GetOnbordingStateInProgress());
    try {
      final result = await GetOnbording.GetOnbordingrepo();
      emit(
        GetOnbordingStateInSussess(useAuthtoken: false, onbordingdata: result),
      );
    } catch (e) {
      GetOnbordingInError(error: e.toString());
    }
  }
    bool OnbordingListIsNotEmty() {
    List<GetOnboardingList> data =
        (state as GetOnbordingStateInSussess).onbordingdata;
    bool mode = data.isNotEmpty;
    return mode;
  }
}
