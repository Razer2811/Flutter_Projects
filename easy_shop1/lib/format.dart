/// Định dạng giá: 21990000 -> "21.990.000 ₫"
String formatPrice(int price) {
  final s = price.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '$buf ₫';
}
