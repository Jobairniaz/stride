import 'package:flutter/material.dart';

import '../../../app/widgets/common.dart';

/// Privacy statement and honest platform limitations.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.bodyLarge;
    Widget p(String text) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(text, style: body),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & limitations')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SectionHeader('Your data'),
          p(
            'Stride has no account, no server and no analytics. Workouts, '
            'height and weight entries are stored only in a database on this '
            'device and are never sent anywhere.',
          ),
          p(
            'You can delete single workouts, clear all history, or delete '
            'your profile and weight history in Settings → Data. Uninstalling '
            'the app removes everything.',
          ),
          const SectionHeader('What Stride does not measure'),
          p(
            'Stride is an interval timer. It does not track GPS, distance, '
            'pace, steps or heart rate.',
          ),
          p(
            'Estimated calories use a standard MET formula with your latest '
            'weight and the time spent in each phase. Walking speed, incline '
            'and fitness are unknown, so treat the number as a rough estimate.',
          ),
          p(
            'BMI is a screening number, not a diagnosis, and does not measure '
            'body composition.',
          ),
          const SectionHeader('Background and lock screen'),
          p(
            'Timing is always calculated from the clock, so the workout is '
            'correct whenever you return to the app.',
          ),
          p(
            'iPhone: iOS usually suspends apps shortly after you leave them '
            'or lock the screen. Spoken countdowns are not guaranteed then. '
            'If notifications are allowed, Stride schedules an alert for each '
            'upcoming phase change instead.',
          ),
          p(
            'Android: voice cues may continue for a while in the background, '
            'but the system or battery savers can stop the app at any time. '
            'Scheduled phase alerts are used as a fallback; without '
            '“Alarms & reminders” access they may arrive late.',
          ),
          p(
            'If the app was closed during a workout, Stride offers to resume '
            'or save it next time you open it. Missed cues are not replayed.',
          ),
          const SectionHeader('Music and earphones'),
          p(
            'Stride asks the system to lower other audio briefly while it '
            'speaks. Whether your music app lowers its volume, pauses or '
            'ignores the request is up to that app and the system.',
          ),
        ],
      ),
    );
  }
}
