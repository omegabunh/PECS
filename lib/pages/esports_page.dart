import 'dart:async';
import 'dart:io';

//Packages
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EsportsPage extends StatefulWidget {
  const EsportsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EsportsPageState();
  }
}

class _EsportsPageState extends State<EsportsPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    var screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        bottom: false,
        child: Builder(
          builder: (BuildContext context) {
            return WebView(
              initialUrl: 'https://www.pubgesports.com/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            );
          },
        ),
      ),
    );
  }
}
