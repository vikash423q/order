import 'package:order/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> put_uid(String uid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString('uid', uid);
}

Future<String> read_uid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('uid');
}

Future<bool> putUser(User user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('uid', user.uid);
  await prefs.setString('name', user.name);
  await prefs.setString('email', user.email);
  await prefs.setString('phone', user.phone);
  await prefs.setBool('phoneVerified', user.phoneVerified);
  return true;
}

Future<User> readUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uid = prefs.getString('uid');
  String name = prefs.getString('name');
  String email = prefs.getString('email');
  String phone = prefs.getString('phone');
  bool phoneVerified = prefs.getBool('phoneVerified');
  return User(uid, name, email, phone, phoneVerified);
}

Future<bool> removeUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('uid');
  await prefs.remove('name');
  await prefs.remove('email');
  await prefs.remove('phone');
  await prefs.remove('phoneVerified');
  return true;
}
