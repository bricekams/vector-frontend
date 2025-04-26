class Entity {
  final String id;
  final String name;
  final String description;
  final EntityType type;
  final String? image;
  final int uploadsCount;

  const Entity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.uploadsCount,
    this.image,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    type: EntityType.values.firstWhere((e) => e.name == json['type']),
    image: json['image'],
    uploadsCount: json['uploadsCount'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type.name,
    'image': image,
    'uploadsCount': uploadsCount,
  };

  Entity copyWith({
    String? id,
    String? name,
    String? description,
    EntityType? type,
    String? image,
    int? uploadsCount,
  }) {
    return Entity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      image: image ?? this.image,
      uploadsCount: uploadsCount ?? this.uploadsCount,
    );
  }

}

enum EntityType {
  personOfInterest,
  publicFigure,
  organization,
  place,
  politicalParty,
  groupOfPeople
}