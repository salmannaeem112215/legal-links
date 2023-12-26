
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String emailKey = "email";
  static const String passKey = "pass";

  // Function to save data in SharedPreferences
  static Future<void> saveUserData(String email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(emailKey, email);
    prefs.setString(passKey, pass);
  }

  // Function to get data from SharedPreferences
  static Future<Map<String, String>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString(emailKey) ?? "";
    String pass = prefs.getString(passKey) ?? "";

    Map<String, String> userData = {
      "email": email,
      "pass": pass,
    };

    return userData;
  }

  // Function to delete data from SharedPreferences
  static Future<void> deleteUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(emailKey);
    prefs.remove(passKey);
  }
}
