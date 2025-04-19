class Entity {
  final String id;
  final String name;
  final String description;
  final EntityType type;
  final String country;
  final String? image;

  const Entity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.country,
    this.image,
  });
}

enum EntityType {
  personOfInterest,
  organization,
  location,
  groupOfPeople,
  publicPerson,
  politicalParty,
}