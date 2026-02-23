class TcgCard {
  String id;
  String name;
  String series;
  String rarity;
  String price;
  String imagePath;

  TcgCard({
    required this.id,
    required this.name,
    required this.series,
    required this.rarity,
    required this.price,
    required this.imagePath,
  });
}