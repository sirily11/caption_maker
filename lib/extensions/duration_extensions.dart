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
}
