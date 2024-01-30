class Profile {
  final dynamic name;
  final dynamic image;

  Profile({required this.name, required this.image});

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      name: map['name'] ?? '',
      image: map['image'] ?? 0,
    );
  }
}