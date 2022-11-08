import 'dart:convert';

//Packages
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/row_widget.dart';

//Porviders
import '../providers/authentication_provider.dart';

//Models
import '../models/player_stats.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  String playerName = '';
  String? apiKey = dotenv.env['apiKey'];
  List<String> platformList = ['steam', 'kakao'];
  String selectedPlatform = 'steam';
  List<int> seasonList = [for (int i = 1; i <= 20; i++) i];
  int selectedSeason = 20;
  PlayerStats result = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return _buildUI();
  }

  void getPlayerData(String selectedPlatform, String playerName, String apiKey,
      int selectedSeason) async {
    result =
        await getPlayer(selectedPlatform, playerName, apiKey, selectedSeason);
    setState(() {});
  }

  bool _visibility = false;
  void _show() {
    setState(() {
      _visibility = true;
    });
  }

  void _hide() {
    setState(() {
      _visibility = false;
    });
  }

  Widget _buildUI() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight,
        width: _deviceWidth,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              'Search',
              primaryAction: IconButton(
                icon: const Icon(
                  Icons.logout,
                ),
                onPressed: () {
                  _auth.logout();
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Season'),
                const SizedBox(width: 10),
                DropdownButton(
                  value: selectedSeason,
                  items: seasonList.map((int item) {
                    return DropdownMenuItem<int>(
                      value: item,
                      child: Text(item.toString()),
                    );
                  }).toList(),
                  onChanged: (dynamic value) {
                    setState(() {
                      selectedSeason = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DropdownButton(
                  value: selectedPlatform,
                  items: platformList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (dynamic value) {
                    setState(() {
                      selectedPlatform = value;
                    });
                  },
                ),
                SizedBox(
                  height: _deviceHeight * 0.07,
                  width: _deviceWidth * 0.65,
                  child: CustomTextField(
                    onEditingComplete: (value) {
                      playerName = value;
                      _visibility ? _hide() : _show();
                      FocusScope.of(context).unfocus();
                      //_callAPI();
                      getPlayerData(selectedPlatform, playerName, apiKey!,
                          selectedSeason);
                      _searchFieldTextEditingController.clear();
                    },
                    hintText: "닉네임을 입력하세요.",
                    obscureText: false,
                    controller: _searchFieldTextEditingController,
                    icon: Icons.search,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _visibility,
              child: Expanded(
                child: ListView(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4.0, //그림자 깊이
                      child: Column(
                        children: [
                          statsRow('플레이어', playerName),
                          statsRow('승', result.wins.toString()),
                          statsRow('탑 10', result.top10s.toString()),
                          statsRow('패', result.losses.toString()),
                          statsRow('킬 수', result.kills.toString()),
                          statsRow('어시스트', result.assist.toString()),
                          statsRow('총 데미지', result.damageDealt.toString()),
                          statsRow('헤드샷', result.headshotKills.toString()),
                          statsRow('저격', result.longestKill.toString()),
                          statsRow('게임 수', result.roundsPlayed.toString()),
                          statsRow('생존 시간', result.mostSurvivalTime.toString()),
                          statsRow('여포', result.roundMostKills.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<PlayerStats> getPlayer(String selectedPlatform, String playerName,
    String apiKey, int selectedSeason) async {
  Uri url = Uri.parse(
    "https://api.pubg.com/shards/$selectedPlatform/players?filter[playerNames]=$playerName",
  );
  Map<String, String> header = {
    "Authorization": "Bearer $apiKey",
    "Accept": "application/vnd.api+json"
  };
  var response = await http.get(url, headers: header);
  print('Response status: ${response.statusCode}');
  var jsonData = response.body;
  final playerId = jsonDecode(jsonData)['data'][0]['id'];

  Uri lifeTimeUrl = Uri.parse(
      "https://api.pubg.com/shards/$selectedPlatform/players/$playerId/seasons/division.bro.official.pc-2018-$selectedSeason?filter[gamepad]=false");
  var lifeTimeResponse = await http.get(lifeTimeUrl, headers: header);
  var lifeTimeJsonData = lifeTimeResponse.body;
  var squadStats = jsonDecode(lifeTimeJsonData)['data']['attributes']
      ['gameModeStats']['squad'];

  PlayerStats stats = PlayerStats.fromJson(squadStats);
  return stats;
}
