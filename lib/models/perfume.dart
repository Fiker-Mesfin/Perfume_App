class Perfume {
  final String name;
  final String image; // Used for Home Screen
  final List<String> gallery;
  final String subtitle;// Used for Details Slider
  final double price;
  final double rating;

  Perfume({
    required this.name,
    required this.image,
    required this.price,
    required this.subtitle,
    this.gallery = const [],// Defaults to an empty list
    required this.rating,
  });
}