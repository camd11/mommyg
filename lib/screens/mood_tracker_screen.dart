import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

class MoodTrackerScreen extends StatefulWidget {
  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  List<MoodEntry> _moodEntries = [];
  int _selectedMood = 3;

  @override
  void initState() {
    super.initState();
    _loadMoodEntries();
  }

  void _loadMoodEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList('mood_entries') ?? [];
    setState(() {
      _moodEntries = entriesJson.map((json) => MoodEntry.fromJson(json)).toList();
    });
  }

  void _saveMoodEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = _moodEntries.map((entry) => entry.toJson()).toList();
    await prefs.setStringList('mood_entries', entriesJson);
  }

  void _addMoodEntry() {
    setState(() {
      _moodEntries.add(MoodEntry(DateTime.now(), _selectedMood));
      _moodEntries.sort((a, b) => b.date.compareTo(a.date));
      if (_moodEntries.length > 30) {
        _moodEntries.removeLast();
      }
    });
    _saveMoodEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mood Tracker')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'How are you feeling today, sweetie?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = index + 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedMood == index + 1 ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ['😢', '😕', '😐', '🙂', '😄'][index],
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              );
            }),
          ),
          ElevatedButton(
            onPressed: _addMoodEntry,
            child: Text('Save Mood'),
          ),
          SizedBox(height: 16),
          Expanded(
            child: _moodEntries.isNotEmpty
                ? MoodChart(moodEntries: _moodEntries)
                : Center(child: Text('No mood data yet. Start tracking your mood!')),
          ),
        ],
      ),
    );
  }
}

class MoodEntry {
  final DateTime date;
  final int mood;

  MoodEntry(this.date, this.mood);

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'mood': mood,
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      DateTime.parse(map['date']),
      map['mood'],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory MoodEntry.fromJson(String source) => MoodEntry.fromMap(jsonDecode(source));
}

class MoodChart extends StatelessWidget {
  final List<MoodEntry> moodEntries;

  MoodChart({required this.moodEntries});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[300],
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    const textStyle = TextStyle(
                      color: Color(0xff68737d),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    );
                    final date = DateTime.now().subtract(Duration(days: 29 - value.toInt()));
                    String text = DateFormat.MMMd().format(date);
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8.0,
                      child: Text(text, style: textStyle),
                    );
                  },
                  interval: 7,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return SizedBox.shrink();
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8.0,
                      child: Text(
                        ['😢', '😕', '😐', '🙂', '😄'][value.toInt() - 1],
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  },
                  reservedSize: 40,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: Color(0xff4e4965), width: 2),
                left: BorderSide(color: Colors.transparent),
                right: BorderSide(color: Colors.transparent),
                top: BorderSide(color: Colors.transparent),
              ),
            ),
            minX: 0,
            maxX: 29,
            minY: 1,
            maxY: 5,
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(30, (index) {
                  final date = DateTime.now().subtract(Duration(days: 29 - index));
                  final entry = moodEntries.firstWhere(
                        (e) => e.date.day == date.day && e.date.month == date.month && e.date.year == date.year,
                    orElse: () => MoodEntry(date, 0),
                  );
                  return FlSpot(index.toDouble(), entry.mood.toDouble());
                }),
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Theme.of(context).colorScheme.primary,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}