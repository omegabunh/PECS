//Packages
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_input_fields.dart';

//Porviders
import '../providers/authentication_provider.dart';

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
  late String playerName;
  late AuthenticationProvider _auth;

  var header;
  var response;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();
  String? apiKey = dotenv.env['apiKey'];
  void _callAPI() async {
    var url = Uri.parse(
      "https://api.pubg.com/shards/steam/players?filter[playerNames]=$playerName",
    );
    //"https://api.pubg.com/shards/steam/matches/f217435a-50cc-4410-856a-e41ddca15495");
    header = {
      "Authorization": "Bearer $apiKey",
      "Accept": "application/vnd.api+json"
    };
    response = await http.get(url, headers: header);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return _buildUI();
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
            CustomTextField(
              onEditingComplete: (value) {
                playerName = value;
                FocusScope.of(context).unfocus();
                _callAPI();
              },
              hintText: "검색...",
              obscureText: false,
              controller: _searchFieldTextEditingController,
              icon: Icons.search,
            ),
          ],
        ),
      ),
    );
  }
}
