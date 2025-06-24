class Entity {
  final String id;
  final String name;
  final String description;
  final EntityType type;
  final String? image;
  final int uploadsCount;
  final List<String>? pseudos;
  final int? phone_1;
  final int? phone_2;
  final String? lastKnownLocation;
  final String? email_1;
  final String? email_2;
  final String? website;
  final String? facebook_1;
  final String? facebook_2;
  final String? instagram;
  final String? twitter;
  final String? linkedin;
  final String? youtube;
  final DateTime? birthDate;
  final Gender? gender;
  final Religion? religion;
  final Region? region;

  const Entity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.uploadsCount,
    this.pseudos,
    this.phone_1,
    this.phone_2,
    this.lastKnownLocation,
    this.email_1,
    this.email_2,
    this.website,
    this.facebook_1,
    this.facebook_2,
    this.instagram,
    this.twitter,
    this.linkedin,
    this.youtube,
    this.birthDate,
    this.image,
    this.gender,
    this.religion,
    this.region,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    type: EntityType.values.firstWhere((e) => e.name == json['type']),
    image: json['image'],
    uploadsCount: json['uploadsCount'],
    pseudos: (json['pseudos'] as List).cast<String>(),
    phone_1: json['phone_1'] != null ? int.parse(json['phone_1']) : null,
    birthDate:
        json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
    phone_2: json['phone_2'] != null ? int.parse(json['phone_2']) : null,
    lastKnownLocation: json['lastKnownLocation'],
    email_1: json['email_1'],
    email_2: json['email_2'],
    website: json['website'],
    facebook_1: json['facebook_1'],
    facebook_2: json['facebook_2'],
    instagram: json['instagram'],
    twitter: json['twitter'],
    linkedin: json['linkedin'],
    youtube: json['youtube'],
    gender: json['gender'] != null ? Gender.values.firstWhere((e) => e.name == json['gender']) : null,
    religion: json['religion'] != null ? Religion.values.firstWhere((e) => e.name == json['religion']) : null,
    region: json['region'] != null ? Region.values.firstWhere((e) => e.name == json['region']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type.name,
    'image': image,
    'uploadsCount': uploadsCount,
    'pseudos': pseudos,
    'phone_1': phone_1,
    'birthDate': birthDate?.toIso8601String(),
    'phone_2': phone_2,
    'lastKnownLocation': lastKnownLocation,
    'email_1': email_1,
    'email_2': email_2,
    'website': website,
    'facebook_1': facebook_1,
    'facebook_2': facebook_2,
    'instagram': instagram,
    'twitter': twitter,
    'linkedin': linkedin,
    'youtube': youtube,
    'gender': gender?.name,
    'religion': religion?.name,
    'region': region?.name,
  };

  Entity copyWith({
    String? id,
    String? name,
    String? description,
    EntityType? type,
    String? image,
    int? uploadsCount,
    List<String>? pseudos,
    int? phone_1,
    DateTime? birthDate,
    int? phone_2,
    String? lastKnownLocation,
    String? email_1,
    String? email_2,
    String? website,
    String? facebook_1,
    String? facebook_2,
    String? instagram,
    String? twitter,
    String? linkedin,
    String? youtube,
    Gender? gender,
    Religion? religion,
    Region? region,
  }) {
    return Entity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      image: image ?? this.image,
      uploadsCount: uploadsCount ?? this.uploadsCount,
      pseudos: pseudos ?? this.pseudos,
      phone_1: phone_1 ?? this.phone_1,
      birthDate: birthDate ?? this.birthDate,
      phone_2: phone_2 ?? this.phone_2,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      email_1: email_1 ?? this.email_1,
      email_2: email_2 ?? this.email_2,
      website: website ?? this.website,
      facebook_1: facebook_1 ?? this.facebook_1,
      facebook_2: facebook_2 ?? this.facebook_2,
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      linkedin: linkedin ?? this.linkedin,
      youtube: youtube ?? this.youtube,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      region: region ?? this.region,
    );
  }
}

enum EntityType {
  personOfInterest,
  publicFigure,
  organization,
  place,
  politicalParty,
  groupOfPeople,
  terrorist,
}

enum Gender { male, female }

enum Religion {
  christian,
  muslim,
  jewish,
  hindu,
  buddhist,
  sikh,
  atheist,
  animist,
  other,
}

enum Region {
  north,
  south,
  east,
  west,
  northWest,
  southWest,
  littoral,
  farNorth,
  center,
  adamawa,
}