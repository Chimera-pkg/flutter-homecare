class Product {
  int id;
  String name;
  String slug;
  String description;
  bool isPublished;
  DateTime createdAt;
  DateTime updatedAt;
  Category category;
  List<Media> media;
  List<Tag>? tags;
  Manufacturer? manufacturer;
  Distributor? distributor;
  // dynamic distributor;
  Thumbnail thumbnail;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.media,
    required this.tags,
    this.manufacturer,
    this.distributor,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        description: json['description'],
        isPublished: json['is_published'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        category: Category.fromJson(json['category']),
        media: List<Media>.from(json['media'].map((x) => Media.fromJson(x))),
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
        manufacturer: json['manufacturer'] != null
            ? Manufacturer.fromJson(json['manufacturer'])
            : null,
        distributor: json['distributor'] != null
            ? Distributor.fromJson(json['distributor'])
            : null,
        // distributor: json['distributor'],
        thumbnail: Thumbnail.fromJson(json['thumbnail']),
      );
}

class Category {
  int id;
  String name;
  String? description;
  int? categoryId;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        // description: json['description'] ?? '-',
        // categoryId: json['category_id'] ?? '-',
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}

class Distributor {
  int? id;
  String? name;
  String? slug;
  String? address;
  String? website;
  String? overview;
  String? about;
  int? userId;
  String? contactName;
  String? contactEmail;
  String? contactMobile;
  String? contactUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  Distributor({
    this.id,
    this.name,
    this.slug,
    this.address,
    this.website,
    this.overview,
    this.about,
    this.userId,
    this.contactName,
    this.contactEmail,
    this.contactMobile,
    this.contactUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Distributor.fromJson(Map<String, dynamic> json) => Distributor(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        address: json["address"],
        website: json["website"],
        overview: json["overview"],
        about: json["about"],
        userId: json["user_id"],
        contactName: json["contact_name"],
        contactEmail: json["contact_email"],
        contactMobile: json["contact_mobile"],
        contactUrl: json["contact_url"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "address": address,
        "website": website,
        "overview": overview,
        "about": about,
        "user_id": userId,
        "contact_name": contactName,
        "contact_email": contactEmail,
        "contact_mobile": contactMobile,
        "contact_url": contactUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Media {
  int id;
  String name;
  String url;
  String type;
  DateTime createdAt;
  DateTime updatedAt;

  Media({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json['id'],
        name: json['name'],
        url: json['url'],
        type: json['type'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}

class Tag {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  Tag({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Manufacturer {
  int? id;
  String? name;
  String? picName;
  String? description;
  String? address;
  String? website;
  String? video;
  String? about;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Manufacturer({
    this.id,
    this.name,
    this.picName,
    this.description,
    this.address,
    this.website,
    this.video,
    this.about,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Manufacturer.fromJson(Map<String, dynamic> json) => Manufacturer(
        id: json["id"],
        name: json["name"],
        picName: json["pic_name"],
        description: json["description"],
        address: json["address"],
        website: json["website"],
        video: json["video"],
        about: json["about"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "pic_name": picName,
        "description": description,
        "address": address,
        "website": website,
        "video": video,
        "about": about,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class User {
  int id;
  // int? creatorId;
  String email;
  String username;
  // String? description;
  bool isVerified;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    // this.creatorId,
    required this.email,
    required this.username,
    // this.description,
    required this.isVerified,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        // creatorId: json['creator_id'] ?? '-',
        email: json['email'],
        username: json['username'],
        // description: json['description'] ?? '-',
        isVerified: json['is_verified'],
        role: json['role'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}

class Thumbnail {
  int id;
  String extname;
  String type;
  String path;
  DateTime createdAt;
  DateTime updatedAt;
  String url;

  Thumbnail({
    required this.id,
    required this.extname,
    required this.type,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
    required this.url,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        id: json['id'],
        extname: json['extname'],
        type: json['type'],
        path: json['path'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        url: json['url'],
      );
}

class Country {
  int id;
  String name;
  String iso;
  String phoneCode;
  DateTime createdAt;
  DateTime updatedAt;

  Country({
    required this.id,
    required this.name,
    required this.iso,
    required this.phoneCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json['id'],
        name: json['name'],
        iso: json['iso'],
        phoneCode: json['phone_code'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}
