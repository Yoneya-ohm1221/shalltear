import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataStore{

  Future<void> setCurrentLobby(String name) async{
    if (name.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('CurrentLobby', name);
    }

  }
}