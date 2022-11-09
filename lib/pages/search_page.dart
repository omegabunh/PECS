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
  PlayerStats soloResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  PlayerStats duoResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  PlayerStats squadResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return _buildUI();
  }

  void getPlayerData(String selectedPlatform, String playerName, String apiKey,
      int selectedSeason) async {
    var stats =
        await getPlayer(selectedPlatform, playerName, apiKey, selectedSeason);
    PlayerStats soloStats = PlayerStats.fromJson(stats['solo']);
    PlayerStats duoStats = PlayerStats.fromJson(stats['duo']);
    PlayerStats squadStats = PlayerStats.fromJson(stats['squad']);
    soloResult = soloStats;
    duoResult = duoStats;
    squadResult = squadStats;
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
                      FocusScope.of(context).unfocus();
                      //_callAPI();
                      getPlayerData(selectedPlatform, playerName, apiKey!,
                          selectedSeason);
                      _searchFieldTextEditingController.clear();
                      _visibility ? _hide() : _show();
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
                      child: Text(
                        playerName,
                        style: const TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4.0, //그림자 깊이
                      child: const Text(
                        'Solo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4.0, //그림자 깊이
                      child: Column(
                        children: [
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow('게임 수',
                                        soloResult.roundsPlayed.toString()),
                                  ),
                                  Container(
                                    child: statsRow(
                                        '탑 10', soloResult.top10s.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '킬 수', soloResult.kills.toString()),
                                  ),
                                  Container(
                                    child: statsRow('총 데미지',
                                        soloResult.damageDealt.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '승', soloResult.wins.toString()),
                                  ),
                                  Container(
                                    child: statsRow(
                                        '패', soloResult.losses.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '어시스트', soloResult.assist.toString()),
                                  ),
                                  Container(
                                    child: statsRow('헤드샷',
                                        soloResult.headshotKills.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '저격', '${soloResult.longestKill}m'),
                                  ),
                                  Container(
                                    child: statsRow('최다 킬',
                                        soloResult.roundMostKills.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow('생존 시간',
                                        soloResult.mostSurvivalTime.toString()),
                                  ),
                                  Container(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4.0, //그림자 깊이
                      child: const Text(
                        'Duo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4.0, //그림자 깊이
                      child: Column(
                        children: [
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow('게임 수',
                                        duoResult.roundsPlayed.toString()),
                                  ),
                                  Container(
                                    child: statsRow(
                                        '탑 10', duoResult.top10s.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '킬 수', duoResult.kills.toString()),
                                  ),
                                  Container(
                                    child: statsRow('총 데미지',
                                        duoResult.damageDealt.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '승', duoResult.wins.toString()),
                                  ),
                                  Container(
                                    child: statsRow(
                                        '패', duoResult.losses.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '어시스트', duoResult.assist.toString()),
                                  ),
                                  Container(
                                    child: statsRow('헤드샷',
                                        duoResult.headshotKills.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '저격', '${duoResult.longestKill}m'),
                                  ),
                                  Container(
                                    child: statsRow('최다 킬',
                                        duoResult.roundMostKills.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow('생존 시간',
                                        duoResult.mostSurvivalTime.toString()),
                                  ),
                                  Container(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4.0, //그림자 깊이
                      child: const Text(
                        'Squad',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4.0, //그림자 깊이
                      child: Column(
                        children: [
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow('게임 수',
                                        squadResult.roundsPlayed.toString()),
                                  ),
                                  Container(
                                    child: statsRow(
                                        '탑 10', squadResult.top10s.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '킬 수', squadResult.kills.toString()),
                                  ),
                                  Container(
                                    child: statsRow('총 데미지',
                                        squadResult.damageDealt.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '승', squadResult.wins.toString()),
                                  ),
                                  Container(
                                    child: statsRow(
                                        '패', squadResult.losses.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '어시스트', squadResult.assist.toString()),
                                  ),
                                  Container(
                                    child: statsRow('헤드샷',
                                        squadResult.headshotKills.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '저격', '${squadResult.longestKill}m'),
                                  ),
                                  Container(
                                    child: statsRow('최다 킬',
                                        squadResult.roundMostKills.toString()),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    child: statsRow(
                                        '생존 시간',
                                        squadResult.mostSurvivalTime
                                            .toString()),
                                  ),
                                  Container(),
                                ],
                              ),
                            ],
                          ),
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

Future<dynamic> getPlayer(String selectedPlatform, String playerName,
    String apiKey, int selectedSeason) async {
  try {
    Uri url = Uri.parse(
      "https://api.pubg.com/shards/$selectedPlatform/players?filter[playerNames]=$playerName",
    );
    Map<String, String> header = {
      "Authorization": "Bearer $apiKey",
      "Accept": "application/vnd.api+json"
    };
    var response = await http.get(url, headers: header);
    print('Response status: ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        var jsonData = response.body;
        final playerId = jsonDecode(jsonData)['data'][0]['id'];
        Uri lifeTimeUrl = Uri.parse(
            "https://api.pubg.com/shards/$selectedPlatform/players/$playerId/seasons/division.bro.official.pc-2018-$selectedSeason?filter[gamepad]=false");
        var lifeTimeResponse = await http.get(lifeTimeUrl, headers: header);
        var lifeTimeJsonData = lifeTimeResponse.body;
        var stats =
            jsonDecode(lifeTimeJsonData)['data']['attributes']['gameModeStats'];
        return stats;
      default:
        throw Exception(response.reasonPhrase);
    }
  } catch (e) {
    rethrow;
  }
}
