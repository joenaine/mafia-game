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

List<String> mergeDuplicatedNames(List<String> names) {
  Map<String, int> nameCountMap = {};
  List<String> mergedNames = [];

  // Count occurrences of each name
  for (String name in names) {
    nameCountMap[name] = (nameCountMap[name] ?? 0) + 1;
  }

  // Merge names and add to the mergedNames list
  nameCountMap.forEach((name, count) {
    String mergedName = (count > 1) ? name : name;
    mergedNames.add(mergedName);
  });

  return mergedNames;
}
