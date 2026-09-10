import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    print('DEBUG: Attempting to save to Cache -> Key: $key, Value: $value (Type: ${value.runtimeType})');
    
    if (value == null) {
      print('DEBUG: Save failed - value is null');
      return false;
    }

    bool result = false;
    if (value is String) {
      result = await sharedPreferences.setString(key, value);
    } else if (value is int) {
      result = await sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      result = await sharedPreferences.setBool(key, value);
    } else if (value is double) {
      result = await sharedPreferences.setDouble(key, value);
    } else {
      // If it's something else (like a number coming as string), try to force it to string
      result = await sharedPreferences.setString(key, value.toString());
    }

    print('DEBUG: Save Result for $key: $result');
    return result;
  }

  static Future<bool> removeData({required String key}) async {
    print('DEBUG: Removing from Cache -> Key: $key');
    return await sharedPreferences.remove(key);
  }
}
