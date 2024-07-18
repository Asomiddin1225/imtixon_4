import 'package:flutter/material.dart';
import 'package:imtixon_4/cubt/theme_cubit.dart';
import 'package:provider/provider.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: themeCubit.state,
            onChanged: (bool value) {
              themeCubit.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}