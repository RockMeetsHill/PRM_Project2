import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/publication.dart';

class LibraryProvider with ChangeNotifier {
  List<Publication> _savedPublications = [];
  static const String _prefsKey = 'saved_publications';

  List<Publication> get savedPublications => _savedPublications;

  LibraryProvider() {
    _loadLibrary();
  }

  Future<void> _loadLibrary() async {
    final prefs = await SharedPreferences.getInstance();
    final String? publicationsJson = prefs.getString(_prefsKey);
    
    if (publicationsJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(publicationsJson);
        _savedPublications = decoded.map((item) => Publication.fromMap(item)).toList();
      } catch (e) {
        debugPrint('Error loading saved publications: $e');
        _savedPublications = [];
      }
    }
    notifyListeners();
  }

  bool isSaved(String id) {
    return _savedPublications.any((pub) => pub.id == id);
  }

  Future<void> toggleSaved(Publication publication) async {
    final bool currentlySaved = isSaved(publication.id);
    
    if (currentlySaved) {
      _savedPublications.removeWhere((pub) => pub.id == publication.id);
    } else {
      _savedPublications.add(publication);
    }
    
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> mappedList = _savedPublications.map((pub) => pub.toMap()).toList();
    final String jsonString = jsonEncode(mappedList);
    await prefs.setString(_prefsKey, jsonString);
  }
}
