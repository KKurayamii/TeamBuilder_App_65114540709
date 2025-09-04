class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types; // แสดงประเภทจริงของโปเกม่อน

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
  });
}

