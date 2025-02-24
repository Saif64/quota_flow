import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
