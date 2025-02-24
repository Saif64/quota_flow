import 'package:flutter/material.dart';

import 'features/home/view/quota_home_page/quota_home_page.dart';

void main() {
  runApp(SimpleQuoteApp());
}

class SimpleQuoteApp extends StatelessWidget {
  const SimpleQuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Quote App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: QuoteHomePage(),
    );
  }
}
