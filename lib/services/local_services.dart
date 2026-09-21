import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/data/user_data_model.dart';
import '../app/modules/registration/models/country_list_model.dart';

class LocalServices {
  static const _keyToken = 'token';
  static const _keyQForm = 'qForm';
  static const _keyUser = 'user';
  static const _keyCountryList = 'countryList';

  // Write token
  static Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // Read token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Write QForm
  static Future<void> storeQForm(String qForm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyQForm, qForm);
  }

  // Read QForm
  static Future<String?> getQForm() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyQForm);
  }

  // Store user
  static Future<void> storeUser(UserDataModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final value = json.encode(user);
    await prefs.setString(_keyUser, value);
  }

  // Read user
  static Future<UserDataModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyUser);
    return value == null ? null : UserDataModel.fromJson(json.decode(value));
  }

  // Store country list
  static Future<void> storeCountryList(CountryListModel countryList) async {
    final prefs = await SharedPreferences.getInstance();
    final value = json.encode(countryList);
    await prefs.setString(_keyCountryList, value);
  }

  // Read country list
  static Future<CountryListModel?> getCountryList() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyCountryList);
    return value == null ? null : CountryListModel.fromJson(json.decode(value));
  }

  // Delete all data
  static Future<void> deleteData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
