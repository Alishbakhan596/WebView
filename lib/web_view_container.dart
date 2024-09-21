import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final String url;

  const WebViewContainer({super.key, required this.url});
  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late final WebViewController controller;
  var loadingPercentage = 0;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()..loadRequest(Uri.parse(widget.url));
    controller
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("SnackBar", onMessageReceived: (message) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message.message)));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web View"),
        actions: [
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () async {
                    final messanger = ScaffoldMessenger.of(context);
                    if (await controller.canGoBack()) {
                      await controller.goBack();
                    } else {
                      messanger.showSnackBar(
                          SnackBar(content: Text("No Back History Found")));
                      return;
                    }
                  }),
              IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () async {
                    final messanger = ScaffoldMessenger.of(context);
                    if (await controller.canGoBack()) {
                      await controller.goForward();
                    } else {
                      messanger.showSnackBar(
                          SnackBar(content: Text("No Forward History Found")));
                    }
                  }),
              IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: () {
                    controller.reload();
                  }),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(value: loadingPercentage / 100.0),
        ],
      ),
    );
  }
}
