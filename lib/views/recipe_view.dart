import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  final String postUrl;
  RecipeView({required this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late String finalUrl;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    if (widget.postUrl.contains("http://")) {
      finalUrl = widget.postUrl.replaceAll("http://", "https://");
    } else {
      finalUrl = widget.postUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: Platform.isIOS ? 60.0 : 40.0,
                  left: 24.0,
                  right: 24.0,
                  bottom: 16.0),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff213A50), Color(0xff071930)])),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment:
                    kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Text(
                    'KnowUr',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Recipe',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: finalUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  setState(() {
                    _controller.complete(webViewController);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
