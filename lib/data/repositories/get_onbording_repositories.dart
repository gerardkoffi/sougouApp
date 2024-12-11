
import 'package:prime_web/data/model/get_onbording_model.dart';
import 'package:prime_web/utils/api.dart';

class GetOnbording {
  static Future<List<GetOnboardingList>> GetOnbordingrepo() async {
    try {
      final result = await ApiCall.getapi(
        url: ApiCall.getOnbording,
        useAuthToken: false,
      );

      if (result['error'] == false) {
        var data = result['data']['data'];
        return (data as List).map(
          (e) {
            return GetOnboardingList.fromJson(e);
          },
        ).toList();
      } else {
        print('this is get Onbording error is true');
        throw 'this is get Onbording error is true';
      }
    } catch (e) {
      print('This is error : $e');
      throw '$e';
    }
  }
}
