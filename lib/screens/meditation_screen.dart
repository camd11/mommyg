import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  int selectedMeditation = 0;

  final List<Map<String, String>> meditations = [
    {
      'title': 'Breathing Exercise',
      'text': 'Close your eyes, sweetie. Take a deep breath in through your nose, counting to four. Hold it for a moment, then exhale slowly through your mouth, counting to six. Let\'s do this five times together.',
    },
    {
      'title': 'Positive Affirmations',
      'text': 'Repeat after me, darling: I am loved. I am worthy. I am strong. I am capable of great things. I believe in myself.',
    },
    {
      'title': 'Gratitude Meditation',
      'text': 'Think of three things you\'re grateful for today, my love. It can be something small, like a warm cup of tea, or something big, like a friend who always supports you. Let\'s focus on these blessings for a moment.',
    },
  ];

  @override
  void initState() {
    super.initState();
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> speak(String text) async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      await flutterTts.speak(text);
      setState(() {
        isPlaying = true;
      });
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Guided Meditation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a meditation, sweetie:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: meditations.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(meditations[index]['title']!),
                      onTap: () {
                        setState(() {
                          selectedMeditation = index;
                        });
                      },
                      selected: selectedMeditation == index,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              meditations[selectedMeditation]['title']!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(meditations[selectedMeditation]['text']!),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => speak(meditations[selectedMeditation]['text']!),
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
              label: Text(isPlaying ? 'Stop' : 'Start Meditation'),
            ),
          ],
        ),
      ),
    );
  }
}