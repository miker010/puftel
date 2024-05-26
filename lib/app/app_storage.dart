import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static SharedPreferences? prefs;

  static Future<SharedPreferences> _getPrefs() async{
    if (prefs==null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs!;
  }

  static Future<bool> getIsAgreed() async {
    final prefs = await _getPrefs();
    var newValue = await prefs.getBool("AGREED") ?? false;
    return newValue;
  }

  static Future setIsInternational() async {
    final prefs = await _getPrefs();
    await prefs.setBool("IS_INT", true);
  }

  static Future<bool> getIsInternational() async {
    final prefs = await _getPrefs();
    var newValue = await prefs.getBool("IS_INT") ?? false;
    return newValue;
  }

  static Future setIsAgreed() async {
    final prefs = await _getPrefs();
    await prefs.setBool("AGREED", true);
  }

  static Future getNewId(String entity) async {
    final prefs = await _getPrefs();
    var newValue = (await prefs.getInt(entity) ?? 0) + 1;
    await prefs.setInt(entity, newValue);
    return newValue;
  }
}