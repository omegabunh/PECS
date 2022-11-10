// ignore_for_file: file_names

String intToTimeLeft(num value) {
  num h, m, s;

  h = value ~/ 3600;
  m = ((value - h * 3600)) ~/ 60;
  s = value - (h * 3600) - (m * 60);

  String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();
  String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();
  String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();
  String result = "$hourLeft:$minuteLeft:$secondsLeft";

  return result;
}
