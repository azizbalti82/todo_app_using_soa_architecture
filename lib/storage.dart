import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('auth_token');
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
}