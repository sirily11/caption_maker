extension DurationToString on Duration {
  String get shortString {
    if (this == null) {
      return "00:00";
    }
    int secs = this.inSeconds;
    int min = secs ~/ 60;
    int sec = secs % 60;

    String minS = min < 10 ? "0$min" : "$min";
    String secS = sec < 10 ? "0$sec" : "$sec";
    return "$minS:$secS";
  }

  /// get srt format timestamp
  String get srtString {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String threeDigits(int n) {
      if (n > 10) return "0$n";
      if (n >= 100) return "$n";
      return "00$n";
    }

    String twoDigitHours = twoDigits(inHours);
    String twoDigitMinutes =
        twoDigits(inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds =
        twoDigits(inSeconds.remainder(Duration.secondsPerMinute));
    String threeDigitMillions =
        threeDigits(inMicroseconds.remainder(Duration.millisecondsPerSecond));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds,$threeDigitMillions";
  }
}
