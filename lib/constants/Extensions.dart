extension StringExtension on String {
  List<String> get words => this.split(' ');

  String get capitalize {
    if (this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + this.substring(1);
  }

  String get capitalizeEachWord {
    List<String> words = this.words;
    List<String> capitalizedWords =
        words.map((word) => word.capitalize).toList();
    return capitalizedWords.join(' ');
  }

  String get removeAndCapitalize {
    String result = this.replaceAll('-', ' ');

    List<String> capitalizedWords =
        result.split(' ').map((word) => word.capitalize).toList();

    // Join the capitalized words back into a single string
    String finalResult = capitalizedWords.join(' ');

    return finalResult;
  }
}
