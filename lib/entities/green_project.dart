class GreenProject {
  final String name;
  final String treeType;
  final String imageUrl;
  final String? date; // Optional: for "Yesterday" or other timestamps

  GreenProject({
    required this.name,
    required this.treeType,
    required this.imageUrl,
    this.date,
  });


}