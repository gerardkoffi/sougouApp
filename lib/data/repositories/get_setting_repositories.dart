import 'package:sougou_app/data/model/get_setting_model.dart';
import 'package:sougou_app/utils/api.dart';

class Getsetting {
  static Future<GetSettingModel> Getsettingrepo() async {
    try {
      final result = await ApiCall.getapi(
        url: ApiCall.getSystemSettings,
        useAuthToken: false,
      );

      final data = await result['data'];

      if (result['error'] == false) {
      
        return GetSettingModel.fromJson(data);
      } else {
        print('this is get setting data error is true');
      }
    } catch (e, st) {
      print('This Get Setting is error : $e,$st');
    }
    return GetSettingModel.fromJson({});
  }
}
