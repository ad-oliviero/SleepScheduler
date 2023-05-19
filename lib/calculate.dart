import 'package:flutter/material.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({
    Key? key,
  }) : super(key: key);

  @override
  CalculatePageState createState() => CalculatePageState();
}

class CalculatePageState extends State<CalculatePage> {
  TimeOfDay _selectedStartSleepTime = TimeOfDay.now();
  late TimeOfDay _selectedWakeUpTime;
  Duration _selectedSleepDurationTime = const Duration(hours: 7, minutes: 30);

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
    _selectedWakeUpTime = _addTime(TimeOfDay.now(), _selectedSleepDurationTime);
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
                  _selectedStartSleepTime = value!;
                  _selectedWakeUpTime = _addTime(
                      _selectedStartSleepTime, _selectedSleepDurationTime);
                });
              });
            },
            child: Text(
                "Start sleeping at: ${_selectedStartSleepTime.format(context)}"),
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
                initialTime: _addTime(now, _selectedSleepDurationTime),
              ).then((value) {
                setState(() {
                  _selectedWakeUpTime = value!;
                  _selectedStartSleepTime =
                      _subtractTime(now, _selectedSleepDurationTime);
                  _selectedSleepDurationTime = const Duration(hours: 7);
                });
              });
            },
            child: Text("Wake up at: ${_selectedWakeUpTime.format(context)}"),
          ),
        ],
      ),
    );
  }
}
