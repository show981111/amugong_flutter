import 'package:shared_preferences/shared_preferences.dart';

class CachedSharedPreference {
  SharedPreferences sharedPreferences;

  final cachedKeyList = {
    SharedPreferenceKey.AccessToken,
  };

  Map<String, dynamic> map = Map();

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences != null)
      for (String key in cachedKeyList) {
        map[key] = sharedPreferences.get(key);
      }
  }

  bool haveUser() {
    if (map[SharedPreferenceKey.AccessToken] != null) {
      return true;
    }
    return false;
  }

  String getString(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences.getString(key);
  }

  int getInt(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences.getInt(key);
  }

  bool getBool(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences.getBool(key);
  }

  Future<bool> setString(String key, String value) async {
    bool result = await sharedPreferences.setString(key, value);
    if (result) {
      map[key] = value;
    }
    return result;
  }

  Future<bool> setBool(String key, bool value) async {
    bool result = await sharedPreferences.setBool(key, value);
    if (result) map[key] = value;
    return result;
  }

  Future<bool> setInt(String key, int value) async {
    bool result = await sharedPreferences.setInt(key, value);
    if (result) map[key] = value;
    return result;
  }

  Future<void> clearAll() async {
    await sharedPreferences.clear();
    map = Map();
  }
}

class SharedPreferenceKey {
  static const String AccessToken = "access_token";
  // static const String RefreshToken = "refresh_token";
  // static const String CurrentStore = "current_store";
}
