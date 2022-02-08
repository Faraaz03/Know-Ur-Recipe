class RecipeModel {
  String url;
  String image;
  String label;
  String source;

  RecipeModel(
      {required this.url,
      required this.image,
      required this.label,
      required this.source});

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    return RecipeModel(
        url: parsedJson['url'],
        image: parsedJson['image'],
        label: parsedJson['label'],
        source: parsedJson['source']);
  }
}
