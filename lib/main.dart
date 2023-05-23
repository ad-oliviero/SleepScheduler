import 'package:flutter/material.dart';
import 'calculate.dart';
import 'sleepstart.dart';
import 'wakeup.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    TimeOfDay now = TimeOfDay.now();
    Duration cycleDuration = const Duration(minutes: 90);
    Duration sleepAmount = Duration(minutes: cycleDuration.inMinutes * 6);
    return MaterialApp(
      title: 'Sleep Scheduler',
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Sleep Scheduler")),
        ),
        body: HomePage(
          startSleepTime: now,
          wakeUpTime: addTime(now, sleepAmount),
          cycleDuration: cycleDuration,
          sleepAmount: sleepAmount,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage(
      {Key? key,
      required this.startSleepTime,
      required this.wakeUpTime,
      required this.cycleDuration,
      required this.sleepAmount})
      : super(key: key);
  final TimeOfDay startSleepTime;
  final TimeOfDay wakeUpTime;
  final Duration cycleDuration;
  final Duration sleepAmount;

  @override
  Widget build(BuildContext context) {
    TimeOfDay now = TimeOfDay.now();
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              showTimePicker(
                context: context,
                initialTime: now,
              ).then((value) {
                if (value != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SleepStartPage(
                        sleepAmount: sleepAmount,
                        startTime: value,
                        cycleDuration: cycleDuration,
                      ),
                    ),
                  );
                }
              });
            },
            child: Text("Start sleeping at: ${startSleepTime.format(context)}"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              showTimePicker(
                context: context,
                initialTime: addTime(now, sleepAmount),
              ).then((value) {
                if (value != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WakeUpPage(
                        sleepAmount: sleepAmount,
                        wakeUpTime: value,
                        cycleDuration: cycleDuration,
                      ),
                    ),
                  );
                }
              });
            },
            child: Text("Wake up at: ${wakeUpTime.format(context)}"),
          ),
        ],
      ),
    );
  }
}
