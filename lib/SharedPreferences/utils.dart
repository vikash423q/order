import 'package:order/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> put_uid(String uid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool didUpdate = await prefs.setString('uid', uid);
  return didUpdate;
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
  return true;
}

Future<User> readUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String uid = prefs.getString('uid');
  String name = prefs.getString('name');
  String email = prefs.getString('email');
  String phone = prefs.getString('phone');
  return User(uid, name, email, phone);
}

Future<bool> removeUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('uid');
  await prefs.remove('name');
  await prefs.remove('email');
  await prefs.remove('phone');
  return true;
}
