import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalStorage {
  final SharedPreferences _prefs;
  final FirebaseAuth _firebaseAuth;
  String? _uid;

  UserLocalStorage(this._prefs, this._firebaseAuth);

  void create() {
    _uid = _firebaseAuth.currentUser?.uid;
  }

  String _key(String key) {
    if (_uid == null) throw Exception('User is not logged in');
    return 'user_${_uid}_$key';
  }

  Future<void> set(String key, String value) async {
    await _prefs.setString(_key(key), value);
  }

  String? get(String key) {
    return _prefs.getString(_key(key));
  }

  Future<void> remove(String key) async {
    await _prefs.remove(_key(key));
  }

  Future<void> clearUserData() async {
    if (_uid == null) return;
    final keysToRemove = _prefs.getKeys();
    for (var key in keysToRemove) {
      await _prefs.remove(key);
    }
  }
}
