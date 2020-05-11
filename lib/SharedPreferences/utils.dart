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
