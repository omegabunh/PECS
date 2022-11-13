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

class _EsportsPageState extends State<EsportsPage>
    with AutomaticKeepAliveClientMixin {
  final Completer<WebViewController> _completerController =
      Completer<WebViewController>();

  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  bool get wantKeepAlive => true;

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () => _goBack(context),
          child: WebView(
            initialUrl: 'https://www.pubgesports.com/',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _completerController.future.then((value) => _controller = value);
              _completerController.complete(webViewController);
            },
            gestureNavigationEnabled: true,
          ),
        ),
      ),
    );
  }
}
