import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class QuoteHomePage extends StatefulWidget {
  const QuoteHomePage({super.key});

  @override
  _QuoteHomePageState createState() => _QuoteHomePageState();
}

class _QuoteHomePageState extends State<QuoteHomePage> {
  final Map<String, List<String>> _quotes = {
    'Motivational': [
      "The best way to predict the future is to invent it.",
      "Dream big and dare to fail.",
      "Believe in yourself and all that you are.",
      "The only limit to our realization of tomorrow is our doubts of today.",
      "Your time is limited, so don’t waste it living someone else’s life.",
      "Difficulties in life are intended to make us better, not bitter.",
      "Push yourself, because no one else is going to do it for you.",
      "Opportunities don't happen, you create them.",
      "Failure is the opportunity to begin again more intelligently.",
      "If you want to achieve greatness, stop asking for permission.",
      "The struggle you’re in today is developing the strength you need for tomorrow.",
      "Do what you have to do until you can do what you want to do.",
      "Every expert was once a beginner.",
      "Your mindset is everything. Train your mind to see the good in every situation.",
      "Stop waiting for the perfect moment. Take the moment and make it perfect.",
    ],
    'Life': [
      "Life is 10% what happens to us and 90% how we react to it.",
      "An unexamined life is not worth living.",
      "Happiness depends upon ourselves.",
      "Enjoy the little things in life, for one day you may look back and realize they were the big things.",
      "Do what you can, with what you have, where you are.",
      "Life isn’t about waiting for the storm to pass, it’s about learning to dance in the rain.",
      "The purpose of life is not to be happy. It is to be useful.",
      "Don’t count the days, make the days count.",
      "Life is what happens when you’re busy making other plans.",
      "Live as if you were to die tomorrow. Learn as if you were to live forever.",
      "The good life is inspired by love and guided by knowledge.",
      "A meaningful life is not being rich, being popular, being highly educated, or being perfect. It is about being real, humble, and able to share ourselves and touch the lives of others.",
      "We make a living by what we get, but we make a life by what we give.",
    ],
    'Success': [
      "The only way to do great work is to love what you do.",
      "Success is not final, failure is not fatal.",
      "Success is stumbling from failure to failure with no loss of enthusiasm.",
      "The road to success and the road to failure are almost exactly the same.",
      "Don’t be afraid to give up the good to go for the great.",
      "If you want to live a happy life, tie it to a goal, not to people or things.",
      "Act as if what you do makes a difference. It does.",
      "Try not to become a man of success, but rather try to become a man of value.",
      "The secret of getting ahead is getting started.",
      "Success usually comes to those who are too busy to be looking for it.",
      "Success is not in what you have, but who you are.",
      "It is hard to fail, but it is worse never to have tried to succeed.",
      "Do what you love and success will follow.",
      "A goal is a dream with a deadline.",
    ],
    'Love': [
      "Love all, trust a few, do wrong to none.",
      "The best thing to hold onto in life is each other.",
      "We accept the love we think we deserve.",
      "To love oneself is the beginning of a lifelong romance.",
      "Being deeply loved by someone gives you strength, while loving someone deeply gives you courage.",
      "Love is composed of a single soul inhabiting two bodies.",
      "The greatest happiness of life is the conviction that we are loved.",
      "At the touch of love, everyone becomes a poet.",
      "A simple ‘I love you’ means more than money.",
      "Love is when the other person's happiness is more important than your own.",
      "The best love is the one that makes you a better person, without changing you into someone other than yourself.",
      "Love doesn't need to be perfect; it just needs to be true.",
    ],
    'Friendship': [
      "Friendship is born at that moment when one person says to another, ‘What! You too? I thought I was the only one.’",
      "A real friend is one who walks in when the rest of the world walks out.",
      "True friendship comes when the silence between two people is comfortable.",
      "A friend is someone who gives you total freedom to be yourself.",
      "Good friends are like stars. You don’t always see them, but you know they’re always there.",
      "Friendship is the only cement that will ever hold the world together.",
      "A true friend never gets in your way unless you happen to be going down.",
      "A single rose can be my garden… a single friend, my world.",
      "The greatest gift of life is friendship, and I have received it.",
      "True friends are never apart, maybe in distance but never in heart.",
      "Friendship isn’t about whom you have known the longest. It’s about who came and never left your side.",
      "Some souls just understand each other upon meeting.",
    ],
    'Happiness': [
      "Happiness is not something ready-made. It comes from your own actions.",
      "The purpose of our lives is to be happy.",
      "If you want to be happy, be.",
      "Happiness is the art of never holding in your mind the memory of any unpleasant thing that has passed.",
      "For every minute you are angry, you lose sixty seconds of happiness.",
      "Happiness depends more on the inward disposition of mind than on outward circumstances.",
      "Be happy for this moment. This moment is your life.",
      "Do more of what makes you happy.",
      "Happiness is not a goal; it is a by-product of a life well-lived.",
      "A smile is happiness you’ll find right under your nose.",
      "The key to being happy is knowing you have the power to choose what to accept and what to let go.",
    ],
    'Faith & Spirituality': [
      "Faith is taking the first step even when you don’t see the whole staircase.",
      "God never said that the journey would be easy, but He did say that the arrival would be worthwhile.",
      "With God, all things are possible.",
      "Faith is the strength by which a shattered world shall emerge into the light.",
      "Your faith can move mountains and your doubt can create them.",
      "To one who has faith, no explanation is necessary. To one without faith, no explanation is possible.",
      "Worry ends where faith begins.",
      "God has a perfect plan for your life. Trust Him.",
      "Prayer is when you talk to God; meditation is when you listen to God.",
      "Let your faith be bigger than your fear.",
    ],
  };

  String _selectedCategory = 'Motivational';
  String _currentQuote = "";
  List<String> _favoriteQuotes = [];
  final FlutterTts _flutterTts = FlutterTts();
  bool _autoRefresh = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadQuoteOfTheDay();
  }

  void _generateQuote() {
    final random = Random();
    setState(() {
      _currentQuote =
          _quotes[_selectedCategory]![random.nextInt(
            _quotes[_selectedCategory]!.length,
          )];
    });
  }

  void _shareQuote() {
    Share.share(_currentQuote);
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteQuotes.contains(_currentQuote)) {
        _favoriteQuotes.remove(_currentQuote);
      } else {
        _favoriteQuotes.add(_currentQuote);
      }
      prefs.setStringList('favorites', _favoriteQuotes);
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteQuotes = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _loadQuoteOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedQuote = prefs.getString('quote_of_the_day');
    String? lastDate = prefs.getString('last_date');

    String today =
        DateTime.now().toString().split(" ")[0]; // Get only the date part
    if (lastDate == today && savedQuote != null) {
      setState(() {
        _currentQuote = savedQuote;
      });
    } else {
      _generateQuote();
      prefs.setString('quote_of_the_day', _currentQuote);
      prefs.setString('last_date', today);
    }
  }

  void _speakQuote() async {
    await _flutterTts.speak(_currentQuote);
  }

  void _toggleAutoRefresh(bool value) {
    setState(() {
      _autoRefresh = value;
      if (_autoRefresh) {
        _startAutoRefresh();
      }
    });
  }

  void _startAutoRefresh() {
    Future.delayed(Duration(seconds: 10), () {
      if (_autoRefresh) {
        _generateQuote();
        _startAutoRefresh();
      }
    });
  }

  void _onSwipe(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      _generateQuote(); // Swipe left for new quote
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _onSwipe,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleFavorite,
          backgroundColor: Colors.black,
          enableFeedback: true,
          elevation: 10,
          child: Icon(
            _favoriteQuotes.contains(_currentQuote)
                ? Icons.favorite
                : Icons.favorite_outline_rounded,
            color:
                _favoriteQuotes.contains(_currentQuote)
                    ? Colors.red
                    : Colors.white,
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                ),
            icon: Icon(Icons.settings_outlined),
          ),
          actionsPadding: EdgeInsets.all(16),
          title: Text(
            'QuoteFlow',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            DropdownButton<String>(
              enableFeedback: true,
              value: _selectedCategory,
              items:
                  _quotes.keys.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  _generateQuote();
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Text(
                  _currentQuote,
                  key: ValueKey<String>(_currentQuote),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _favoriteQuotes.contains(_currentQuote)
                          ? Icons.favorite
                          : Icons.favorite_outline_rounded,
                      color:
                          _favoriteQuotes.contains(_currentQuote)
                              ? Colors.red
                              : Colors.green,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                  IconButton(
                    icon: Icon(Icons.ios_share),
                    onPressed: _shareQuote,
                  ),
                ],
              ),

              // SwitchListTile(
              //   title: Text("Auto Refresh Quotes"),
              //   value: _autoRefresh,
              //   onChanged: _toggleAutoRefresh,
              // ),
              TextButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesScreen(_favoriteQuotes),
                      ),
                    ),
                child: Text(
                  "View Favorites",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteQuotes;
  final Random _random = Random();

  FavoritesScreen(this.favoriteQuotes, {super.key});

  /// Generates a random soft color for the background
  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(200) + 50, // Avoiding very dark colors
      _random.nextInt(200) + 50,
      _random.nextInt(200) + 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Quotes")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.builder(
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
          ),
          itemCount: favoriteQuotes.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getRandomColor(), // Random background color
                borderRadius: BorderRadius.circular(12), // Smooth rounded edges
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                favoriteQuotes[index],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoRefresh = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Load the saved setting from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoRefresh = prefs.getBool('auto_refresh') ?? false;
    });
  }

  /// Save the setting when toggled
  Future<void> _updateAutoRefresh(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_refresh', value);
    setState(() {
      _autoRefresh = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Auto Refresh Quotes"),
            subtitle: const Text("Enable to refresh quotes automatically"),
            value: _autoRefresh,
            onChanged: (value) => _updateAutoRefresh(value),
          ),
        ],
      ),
    );
  }
}
