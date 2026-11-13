/// 1250000 -> "1.250.000"
String vnd(int v) {
  final s = v.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

/// "1.250.000" -> 1250000
int parseVnd(String s) => int.parse(s.replaceAll('.', ''));
