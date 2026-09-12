import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService._();

  static SharedPreferencesService? _instance;
  static SharedPreferences? _prefs;

  static SharedPreferencesService get instance {
    _instance ??= SharedPreferencesService._();
    return _instance ?? SharedPreferencesService._();
  }

  static Future<void> init({SharedPreferences? prefs}) async {
    if (prefs != null) {
      _prefs = prefs;
      return;
    }
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> setAuthToken(String token) async {
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.setString('auth_token', token);
    }
  }

  Future<String?> getAuthToken() async {
    final prefs = _prefs;
    if (prefs != null) {
      return prefs.getString('auth_token');
    }
    return null;
  }

  Future<void> setAuthName(String name) async {
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.setString('auth_name', name);
    }
  }

  Future<String?> getAuthName() async {
    final prefs = _prefs;
    if (prefs != null) {
      return prefs.getString('auth_name');
    }
    return null;
  }

  Future<void> clearAuthData() async {
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.remove('auth_token');
      await prefs.remove('auth_name');
    }
  }

  Future<void> setFavoriteProductIds(List<String> ids) async {
    final prefs = _prefs;
    if (prefs != null) {
      await prefs.setStringList('favorite_product_ids', ids);
    }
  }

  Future<List<String>> getFavoriteProductIds() async {
    final prefs = _prefs;
    if (prefs != null) {
      return prefs.getStringList('favorite_product_ids') ?? [];
    }
    return [];
  }

  Future<void> addFavoriteProductId(int id) async {
    final ids = (await getFavoriteProductIds()).toSet();
    ids.add(id.toString());
    await setFavoriteProductIds(ids.toList());
  }

  Future<void> removeFavoriteProductId(int id) async {
    final ids = (await getFavoriteProductIds()).toSet();
    ids.remove(id.toString());
    await setFavoriteProductIds(ids.toList());
  }

  Future<bool> isFavoriteProduct(int id) async {
    final ids = await getFavoriteProductIds();
    return ids.contains(id.toString());
  }
}
