import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PathsScreen extends StatefulWidget {
  const PathsScreen({Key? key}) : super(key: key);

  static const routeName = '/paths-screen';

  @override
  State<PathsScreen> createState() => _PathsScreenState();
}

class _PathsScreenState extends State<PathsScreen> {
  @override
  // void initState() {
  //    super.initState();
  //    // Enable virtual display.
  //    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  //  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paths',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.black)),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: const WebView(
        initialUrl: 'https://www.sikhitothemax.org/', 
        javascriptMode: JavascriptMode.unrestricted,   
      ),
    );
  }
}
