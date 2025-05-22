class Entity {
  final String id;
  final String name;
  final String description;
  final EntityType type;
  final String? image;
  final int uploadsCount;
  final List<String>? pseudos;
  final int? phone;
  final DateTime? birthDate;

  const Entity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.uploadsCount,
    this.pseudos,
    this.phone,
    this.birthDate,
    this.image,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    type: EntityType.values.firstWhere((e) => e.name == json['type']),
    image: json['image'],
    uploadsCount: json['uploadsCount'],
    pseudos: (json['pseudos'] as List).cast<String>(),
    phone: json['phone'] != null ? int.parse(json['phone']) : null,
    birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type.name,
    'image': image,
    'uploadsCount': uploadsCount,
    'pseudos': pseudos,
    'phone': phone,
    'birthDate': birthDate?.toIso8601String(),
  };

  Entity copyWith({
    String? id,
    String? name,
    String? description,
    EntityType? type,
    String? image,
    int? uploadsCount,
    List<String>? pseudos,
    int? phone,
    DateTime? birthDate,
  }) {
    return Entity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      image: image ?? this.image,
      uploadsCount: uploadsCount ?? this.uploadsCount,
      pseudos: pseudos ?? this.pseudos,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
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