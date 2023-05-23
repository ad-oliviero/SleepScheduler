import 'package:flutter/material.dart';
import 'calculate.dart';

class WakeUpPage extends StatelessWidget {
  const WakeUpPage(
      {Key? key,
      required this.sleepAmount,
      required this.wakeUpTime,
      required this.cycleDuration})
      : super(key: key);
  final Duration sleepAmount;
  final TimeOfDay wakeUpTime;
  final Duration cycleDuration;

  List<Widget> _genTimes(BuildContext context) {
    TimeOfDay startTime = wakeUpTime;
    Duration currentSleepAmount = Duration.zero;
    List<Widget> times = [];
    while (currentSleepAmount <= sleepAmount) {
      times.add(
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Text(
              startTime.format(context),
              style: const TextStyle(fontSize: 20),
            ),
            trailing: Text(
                '${currentSleepAmount.inHours.toString()}:${(currentSleepAmount.inMinutes - (currentSleepAmount.inHours * 60)).toString().padLeft(2, '0')}'),
          ),
        ),
      );
      startTime = subTime(startTime, cycleDuration);
      currentSleepAmount = Duration(
          minutes: currentSleepAmount.inMinutes + cycleDuration.inMinutes);
    }
    return times.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wake up at: ${wakeUpTime.format(context)}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                'Sleep for ${sleepAmount.inMinutes} minutes',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sleep at:',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Sleep amount:',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: _genTimes(context)),
          )
        ],
      ),
    );
  }
}
