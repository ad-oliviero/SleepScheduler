import 'package:flutter/material.dart';
import 'calculate.dart';

class SleepStartPage extends StatelessWidget {
  const SleepStartPage(
      {Key? key,
      required this.sleepAmount,
      required this.startTime,
      required this.cycleDuration})
      : super(key: key);
  final Duration sleepAmount;
  final TimeOfDay startTime;
  final Duration cycleDuration;

  List<Widget> _genTimes(BuildContext context) {
    TimeOfDay wakeUpTime = startTime;
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
              wakeUpTime.format(context),
              style: const TextStyle(fontSize: 20),
            ),
            trailing: Text(
                '${currentSleepAmount.inHours.toString()}:${(currentSleepAmount.inMinutes - (currentSleepAmount.inHours * 60)).toString().padLeft(2, '0')}'),
          ),
        ),
      );
      wakeUpTime = addTime(wakeUpTime, cycleDuration);
      currentSleepAmount = Duration(
          minutes: currentSleepAmount.inMinutes + cycleDuration.inMinutes);
    }
    return times;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start sleeping at: ${startTime.format(context)}'),
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
                  'Wake up at:',
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
