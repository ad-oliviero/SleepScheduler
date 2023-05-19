import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late Duration _sleepAmount;
  final Duration _cycleDuration = const Duration(minutes: 90);
  int _cycleAmount = 5;

  final defaults = const {
    "cycleDuration": Duration(minutes: 90),
    "cycleAmount": 5,
  };

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

  TimeOfDay _subTime(TimeOfDay time, Duration duration) {
    return _addTime(
        time, Duration(hours: -duration.inHours, minutes: -duration.inMinutes));
  }

  double durationToHours(Duration duration) {
    double hours = duration.inHours.toDouble();
    double minutes = duration.inMinutes.toDouble() - (hours * 60);
    return hours + minutes / 60;
  }

  @override
  void initState() {
    super.initState();
    _sleepAmount = Duration(minutes: _cycleDuration.inMinutes * _cycleAmount);
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
                  _startSleepTime = _subTime(now, _sleepAmount);
                  _sleepAmount = const Duration(hours: 7);
                });
              });
            },
            child: Text("Wake up at: ${_wakeUpTime.format(context)}"),
          ),
          const SizedBox(height: 20),
          const Divider(height: 20),
          const Text("Sleep Amount", style: TextStyle(fontSize: 20)),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    int newAmount =
                        _sleepAmount.inMinutes - _cycleDuration.inMinutes;
                    if (newAmount >= durationToHours(_cycleDuration)) {
                      _sleepAmount = Duration(minutes: newAmount);
                    }
                  });
                },
                icon: const Icon(Icons.remove),
              ),
              Expanded(
                child: Slider(
                  value: durationToHours(_sleepAmount),
                  min: durationToHours(_cycleDuration),
                  max: 24,
                  divisions: (24 - durationToHours(_cycleDuration)) ~/
                      (_cycleDuration.inMinutes / 60),
                  onChanged: (double value) {
                    setState(() {
                      _sleepAmount = Duration(
                        hours: value.toInt(),
                        minutes: ((value % 1) * 60).toInt(),
                      );
                      _cycleAmount =
                          _sleepAmount.inMinutes ~/ _cycleDuration.inMinutes;
                      _wakeUpTime = _addTime(_startSleepTime, _sleepAmount);
                    });
                  },
                ),
              ),
              Center(
                child: Text(
                    "${_sleepAmount.inHours}:${(_sleepAmount.inMinutes - (_sleepAmount.inHours * 60)).toString().padLeft(2, '0')}"),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    int newAmount =
                        _sleepAmount.inMinutes + _cycleDuration.inMinutes;
                    if (newAmount <= 24 * 60) {
                      _sleepAmount = Duration(minutes: newAmount);
                    }
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const Divider(height: 20),
          const Text("Sleep Cycle Information", style: TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          Text(
            "Duration: ${_cycleDuration.inMinutes} minutes",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            "Cycle Amount: $_cycleAmount",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
