import 'package:flutter/material.dart';
import 'package:webview_web/web_view_container.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final TextEditingController _controller = TextEditingController();

  void _searchOrNavigate() {
    String query = _controller.text.trim();
    Uri? uri = Uri.tryParse(query);

    bool isUrl = Uri.parse(query).isAbsolute;

    if (isUrl) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewContainer(url: query)));
    } else {
      String searchUrl = 'https://www.google.com/search?q=$query';
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewContainer(url: searchUrl)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "WebView",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: "Enter URL or Search",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search)),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade700,
                      foregroundColor: Colors.white),
                  onPressed: _searchOrNavigate,
                  child: Text(
                    "GO",
                    style: TextStyle(fontSize: 18),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
