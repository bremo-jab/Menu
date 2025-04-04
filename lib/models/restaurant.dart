class Restaurant {
  final String name;
  final String location;
  final String phone;
  final List<String> menu;

  Restaurant({
    required this.name,
    required this.location,
    required this.phone,
    required this.menu,
  });

  factory Restaurant.fromMap(Map<String, dynamic> data) {
    return Restaurant(
      name: data['r.Name'] ?? '',
      location: data['r.Location'] ?? '',
      phone: data['r.phone'] ?? '',
      menu: List<String>.from(data['menu'] ?? []),
    );
  }
}
