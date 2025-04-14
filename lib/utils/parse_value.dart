double parseValue(String value) {
  try {
    return double.parse(value.replaceAll(RegExp(r'[^0-9.]'), '')).clamp(0, 100);
  } catch (_) {
    return 0.0;
  }
}
