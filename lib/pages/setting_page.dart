//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/top_bar.dart';

//Pages
import '../pages/user_page.dart';

//Provider
import '../providers/theme_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
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
                'Setting',
                primaryAction: IconButton(
                  icon: Icon(
                    Icons.adaptive.arrow_forward,
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserPage(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              SizedBox(
                width: _deviceWidth * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('테마 변경'),
                    Switch.adaptive(
                      value: themeNotifier.isDark,
                      onChanged: (value) {
                        setState(() {
                          themeNotifier.isDark = value;
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
