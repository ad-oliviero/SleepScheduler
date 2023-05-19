import 'package:flutter/material.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({
    Key? key,
  }) : super(key: key);

  @override
  CalculatePageState createState() => CalculatePageState();
}

class CalculatePageState extends State<CalculatePage> {
  TimeOfDay _startSleepTime = TimeOfDay.now();
  late TimeOfDay _wakeUpTime;
  Duration _sleepAmount = const Duration(hours: 7, minutes: 30);
  Duration _cycleDuration = const Duration(minutes: 90);

  TimeOfDay _addTime(TimeOfDay time, Duration duration) {
    int newMinute = time.minute + duration.inMinutes - (duration.inHours * 60);
    int newHour = time.hour + duration.inHours;
    while (newMinute > 60) {
      newMinute -= 60;
      newHour++;
    }
    while (newHour > 24) {
      newHour -= 24;
    }
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  TimeOfDay _subtractTime(TimeOfDay time, Duration duration) {
    return _addTime(
        time, Duration(hours: -duration.inHours, minutes: -duration.inMinutes));
  }

  @override
  void initState() {
    super.initState();
    _wakeUpTime = _addTime(TimeOfDay.now(), _sleepAmount);
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay now = TimeOfDay.now();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
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
                setState(() {
                  _startSleepTime = value!;
                  _wakeUpTime = _addTime(_startSleepTime, _sleepAmount);
                });
              });
            },
            child:
                Text("Start sleeping at: ${_startSleepTime.format(context)}"),
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
                initialTime: _addTime(now, _sleepAmount),
              ).then((value) {
                setState(() {
                  _wakeUpTime = value!;
                  _startSleepTime = _subtractTime(now, _sleepAmount);
                  _sleepAmount = const Duration(hours: 7);
                });
              });
            },
            child: Text("Wake up at: ${_wakeUpTime.format(context)}"),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text("Sleep Amount: "),
              Slider(
                value: _sleepAmount.inHours.toDouble(),
                min: 0,
                max: 24,
                divisions: 24 ~/ (_cycleDuration.inMinutes / 60),
                onChanged: (double value) {
                  setState(() {
                    _sleepAmount = Duration(
                      hours: value.toInt(),
                      minutes: ((value % 1) * 60).toInt(),
                    );
                    _wakeUpTime = _addTime(_startSleepTime, _sleepAmount);
                  });
                },
              ),
              Center(
                child: Text(
                    "${_sleepAmount.inHours}:${(_sleepAmount.inMinutes - (_sleepAmount.inHours * 60)).toString().padLeft(2, '0')}"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
