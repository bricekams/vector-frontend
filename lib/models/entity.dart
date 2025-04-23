class Entity {
  final String id;
  final String name;
  final String description;
  final EntityType type;
  final String? image;

  const Entity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.image,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    type: EntityType.values.firstWhere((e) => e.name == json['type']),
    image: json['image'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type.name,
    'image': image,
  };
}

enum EntityType {
  personOfInterest,
  publicFigure,
  organization,
  place,
  politicalParty,
  groupOfPeople
}