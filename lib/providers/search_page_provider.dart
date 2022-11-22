// ignore_for_file: unused_field, avoid_print

//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

//Models
import '../models/player_stats.dart';

class SearchPageProvider extends ChangeNotifier {
  SearchPageProvider() {
    _db = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
  }

  PlayerStats duoResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  PlayerStats soloResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  PlayerStats squadResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  bool visibility = false;

  late DatabaseService _db;
  bool _disposed = false;
  late NavigationService _navigation;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void getPlayerData(String selectedPlatform, String playerName, String apiKey,
      int selectedSeason) async {
    try {
      var stats = await _db.getPlayer(
          selectedPlatform, playerName, apiKey, selectedSeason);
      if (stats != null) {
        PlayerStats soloStats = PlayerStats.fromJson(stats['solo']);
        PlayerStats duoStats = PlayerStats.fromJson(stats['duo']);
        PlayerStats squadStats = PlayerStats.fromJson(stats['squad']);
        soloResult = soloStats;
        duoResult = duoStats;
        squadResult = squadStats;
      } else {
        duoResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        soloResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        squadResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        hide();
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void show() {
    visibility = true;
    notifyListeners();
  }

  void hide() {
    visibility = false;
    notifyListeners();
  }
}
