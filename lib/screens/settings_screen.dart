import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_preferences.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Consumer<UserPreferences>(
        builder: (context, userPreferences, child) {
          return ListView(
            children: [
              ListTile(
                title: Text('Dark Mode'),
                trailing: Switch(
                  value: userPreferences.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    userPreferences.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ),
              ListTile(
                title: Text('Change Name'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String newName = userPreferences.userName;
                      return AlertDialog(
                        title: Text('Change Your Name'),
                        content: TextField(
                          onChanged: (value) => newName = value,
                          decoration: InputDecoration(hintText: 'Enter your new name'),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                            child: Text('Save'),
                            onPressed: () {
                              userPreferences.setUserName(newName);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              // Add more settings options here
            ],
          );
        },
      ),
    );
  }
}