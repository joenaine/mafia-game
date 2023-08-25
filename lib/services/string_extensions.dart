extension E on String {
  String lastChars(int n) => substring(length - n);
}

extension ShortText on String {
  static String fromText(String text) {
    if (text.length > 10) {
      return '${text.substring(0, 10)}...';
    }
    return text;
  }
}
