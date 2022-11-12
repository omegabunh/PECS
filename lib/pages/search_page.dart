//Packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

//Services
import '../services/database_service.dart';
import '../services/intToTime_service.dart';

//Widgets
import '../widgets/custom_card.dart';

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

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  String? apiKey = dotenv.env['apiKey'];

  String playerName = '';

  List<String> platformList = ['steam', 'kakao'];
  String selectedPlatform = 'steam';

  List<int> seasonList = [for (int i = 1; i <= 25; i++) i];

  int selectedSeason = 20;
  bool _visibility = false;
  PlayerStats soloResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  PlayerStats duoResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  PlayerStats squadResult = PlayerStats(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () {
              _auth.logout();
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
          ),
          height: _deviceHeight,
          width: _deviceWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _seasonSelect(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _platformSelect(),
                  _playerSearch(),
                ],
              ),
              Visibility(
                visible: _visibility,
                child: CustomCard(title: playerName, size: 40.0),
              ),
              _playerData(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seasonSelect() {
    return Row(
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
    );
  }

  Widget _platformSelect() {
    return DropdownButton(
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
    );
  }

  Widget _playerSearch() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CupertinoSearchTextField(
        placeholder: '닉네임을 입력하세요.',
        onSubmitted: (value) {
          if (_searchFieldTextEditingController.text.isNotEmpty) {
            playerName = value;
            FocusScope.of(context).unfocus();
            getPlayerData(
                selectedPlatform, playerName, apiKey!, selectedSeason);
            _show();
          } else {
            _hide();
          }
        },
        controller: _searchFieldTextEditingController,
        autocorrect: false,
      ),
    );
  }

  Widget _playerData() {
    double soloDamage = soloResult.damageDealt / soloResult.roundsPlayed;
    double duoDamage = duoResult.damageDealt / duoResult.roundsPlayed;
    double squadDamage = squadResult.damageDealt / squadResult.roundsPlayed;
    return Visibility(
      visible: _visibility,
      child: Expanded(
        child: ListView(
          children: [
            const CustomCard(
              cardColor: Colors.amber,
              title: 'Solo',
              size: 20.0,
              textColor: Colors.white,
            ),
            CustomCardTable(
              roundPlayed: soloResult.roundsPlayed.toString(),
              top10s: soloResult.top10s.toString(),
              kills: soloResult.kills.toString(),
              damageDealt: soloResult.damageDealt.round().toString(),
              wins: soloResult.wins.toString(),
              losses: soloResult.losses.toString(),
              assists: soloResult.assist.toString(),
              headShotKills: soloResult.headshotKills.toString(),
              longestKill: soloResult.longestKill.round().toString(),
              roundMostKills: soloResult.roundMostKills.toString(),
              mostSurvivalTime: intToTimeLeft(soloResult.mostSurvivalTime),
              averageDeal: soloDamage.toStringAsFixed(2),
            ),
            const CustomCard(
              cardColor: Colors.green,
              title: 'Duo',
              size: 20.0,
              textColor: Colors.white,
            ),
            CustomCardTable(
              roundPlayed: duoResult.roundsPlayed.toString(),
              top10s: duoResult.top10s.toString(),
              kills: duoResult.kills.toString(),
              damageDealt: duoResult.damageDealt.round().toString(),
              wins: duoResult.wins.toString(),
              losses: duoResult.losses.toString(),
              assists: duoResult.assist.toString(),
              headShotKills: duoResult.headshotKills.toString(),
              longestKill: duoResult.longestKill.round().toString(),
              roundMostKills: duoResult.roundMostKills.toString(),
              mostSurvivalTime: intToTimeLeft(duoResult.mostSurvivalTime),
              averageDeal: duoDamage.toStringAsFixed(2),
            ),
            const CustomCard(
              cardColor: Colors.deepPurple,
              title: 'Squad',
              size: 20.0,
              textColor: Colors.white,
            ),
            CustomCardTable(
              roundPlayed: squadResult.roundsPlayed.toString(),
              top10s: squadResult.top10s.toString(),
              kills: squadResult.kills.toString(),
              damageDealt: squadResult.damageDealt.round().toString(),
              wins: squadResult.wins.toString(),
              losses: squadResult.losses.toString(),
              assists: squadResult.assist.toString(),
              headShotKills: squadResult.headshotKills.toString(),
              longestKill: squadResult.longestKill.round().toString(),
              roundMostKills: squadResult.roundMostKills.toString(),
              mostSurvivalTime: intToTimeLeft(squadResult.mostSurvivalTime),
              averageDeal: squadDamage.toStringAsFixed(2),
            ),
          ],
        ),
      ),
    );
  }
}
