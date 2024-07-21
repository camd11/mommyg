import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_preferences.dart';
import '../services/ai_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/voice_input_button.dart';
import 'mood_tracker_screen.dart';
import 'journal_screen.dart';
import 'meditation_screen.dart';
import 'settings_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../utils/custom_page_transition.dart';
import 'affirmations_screen.dart';
import '../services/notification_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  final AIService _aiService = AIService();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isLoading = false;
  bool _isSpeaking = false;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _initTts();
    _notificationService.scheduleDaily();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userName = Provider.of<UserPreferences>(context, listen: false).userName;
      _aiService.updateUserName(userName);
    });
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.9);
    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
  }

  void _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getStringList('chat_messages') ?? [];
    setState(() {
      _messages = messagesJson.map((json) => Map<String, String>.from(jsonDecode(json))).toList();
    });
  }

  void _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = _messages.map((message) => jsonEncode(message)).toList();
    await prefs.setStringList('chat_messages', messagesJson);
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({"role": "user", "content": _controller.text});
        _isLoading = true;
      });

      try {
        final response = await _aiService.getResponse(_controller.text);
        setState(() {
          _messages.add({"role": "ai", "content": response});
          _isLoading = false;
        });
        _saveMessages();
        _speakResponse(response);
      } catch (e) {
        setState(() {
          _messages.add({"role": "ai", "content": "Oh sweetie, I'm having a bit of trouble right now. Can you tell me again what's on your mind?"});
          _isLoading = false;
        });
        _saveMessages();
      }

      _controller.clear();
    }
  }

  void _speakResponse(String text) async {
    if (!_isSpeaking) {
      setState(() => _isSpeaking = true);
      await _flutterTts.speak(text);
    }
  }

  void _stopSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, CustomPageTransition(page: page));
  }

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<UserPreferences>(context).userName;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with MommyG'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Hello, $userName!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.mood),
              title: Text('Mood Tracker'),
              onTap: () {
                Navigator.pop(context);
                _navigateTo(context, MoodTrackerScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Journal'),
              onTap: () {
                Navigator.pop(context);
                _navigateTo(context, JournalScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.spa),
              title: Text('Guided Meditation'),
              onTap: () {
                Navigator.pop(context);
                _navigateTo(context, MeditationScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _navigateTo(context, SettingsScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Daily Affirmations'),
              onTap: () {
                Navigator.pop(context);
                _navigateTo(context, AffirmationsScreen());
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (_messages[index]["role"] == "ai") {
                      _isSpeaking ? _stopSpeaking() : _speakResponse(_messages[index]["content"]!);
                    }
                  },
                  child: ChatBubble(
                    message: _messages[index]["content"]!,
                    isUser: _messages[index]["role"] == "user",
                  ),
                );
              },
            ),
          ),
          if (_isLoading) LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Tell MommyG what\'s on your mind...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                VoiceInputButton(onSpeechResult: (String text) {
                  setState(() {
                    _controller.text = text;
                  });
                  _sendMessage();
                }),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}