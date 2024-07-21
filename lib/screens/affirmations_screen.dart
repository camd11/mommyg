import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AffirmationsScreen extends StatefulWidget {
  @override
  _AffirmationsScreenState createState() => _AffirmationsScreenState();
}

class _AffirmationsScreenState extends State<AffirmationsScreen> {
  List<String> _affirmations = [
    "I am loved and appreciated",
    "I am capable of great things",
    "I believe in myself and my abilities",
    "I am worthy of happiness and success",
    "I am strong and resilient"
  ];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAffirmations();
  }

  void _loadAffirmations() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAffirmations = prefs.getStringList('affirmations');
    if (savedAffirmations != null) {
      setState(() {
        _affirmations = savedAffirmations;
      });
    }
  }

  void _saveAffirmations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('affirmations', _affirmations);
  }

  void _addAffirmation() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _affirmations.add(_controller.text);
        _controller.clear();
      });
      _saveAffirmations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Affirmations'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _affirmations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_affirmations[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _affirmations.removeAt(index);
                      });
                      _saveAffirmations();
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a new affirmation',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addAffirmation,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
