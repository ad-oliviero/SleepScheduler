import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Use Monet colors if available, otherwise use default Material 3
        final lightColorScheme = lightDynamic ??
            ColorScheme.fromSeed(
              seedColor: Colors.blue, // Fallback seed color
              brightness: Brightness.light,
            );
        final darkColorScheme = darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: Colors.blue, // Fallback seed color
              brightness: Brightness.dark,
            );
        return MaterialApp(
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
          ),
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                title: Text('Title'),
              ),
              body: const Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        SleepPage(),
                        WakeUpPage(),
                      ],
                    ),
                  ),
                  TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.bed), text: 'Starting Time'),
                      Tab(icon: Icon(Icons.alarm), text: 'Wake Up Time'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SleepPage extends StatelessWidget {
  const SleepPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Sleep',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class WakeUpPage extends StatelessWidget {
  const WakeUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Wake Up',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
