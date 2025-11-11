// To parse this JSON data, do
//
//     final productResponse = productResponseFromJson(jsonString);

import 'dart:convert';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

class ProductResponse {
  Meta? meta;
  List<Datum> data;

  ProductResponse({
    this.meta,
    List<Datum>? data,
  }) : this.data = data ?? [];

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String? name;
  String? slug;
  String? description;
  bool? isPublished;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? category;
  List<Tag>? tags;
  Thumbnail? thumbnail;
  Distributor? distributor;
  Manufacturer? manufacturer;

  Datum({
    required this.id,
    this.name,
    this.slug,
    this.description,
    this.isPublished,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.tags,
    this.thumbnail,
    this.distributor,
    this.manufacturer,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        isPublished: json["is_published"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
        thumbnail: json["thumbnail"] == null
            ? null
            : Thumbnail.fromJson(json["thumbnail"]),
        distributor: json["distributor"] == null
            ? null
            : Distributor.fromJson(json["distributor"]),
        manufacturer: json["manufacturer"] == null
            ? null
            : Manufacturer.fromJson(json["manufacturer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
        "is_published": isPublished,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "category": category?.toJson(),
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "thumbnail": thumbnail?.toJson(),
        "distributor": distributor?.toJson(),
        "manufacturer": manufacturer?.toJson(),
      };
}

class Category {
  int? id;
  Name? name;
  String? description;
  int? categoryId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    this.id,
    this.name,
    this.description,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: nameValues.map[json["name"]] ?? Name.NOT_LISTED_IN_APP,
        description: json["description"],
        categoryId: json["category_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
        "description": description,
        "category_id": categoryId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

enum Name {
  IMAGING_AND_DIAGNOSTICS,
  IMMUNOHISTOCHEMISTRY,
  LABORATORY_FURNITURE,
  MEDICAL_CONSUMABLES,
  MEDICAL_EQUIPMENT,
  MOLECULAR_DIAGNOSTIC_INSTRUMENT_AND_KITS,
  PRESCRIPTION_DRUG,
  NOT_LISTED_IN_APP,
}

final nameValues = EnumValues({
  "Imaging and diagnostics": Name.IMAGING_AND_DIAGNOSTICS,
  "Immunohistochemistry": Name.IMMUNOHISTOCHEMISTRY,
  "Laboratory furniture": Name.LABORATORY_FURNITURE,
  "Medical consumables": Name.MEDICAL_CONSUMABLES,
  "Medical equipment": Name.MEDICAL_EQUIPMENT,
  "Molecular diagnostic instrument and kits":
      Name.MOLECULAR_DIAGNOSTIC_INSTRUMENT_AND_KITS,
  "Prescription Drug": Name.PRESCRIPTION_DRUG,
  "Not listed in app": Name.NOT_LISTED_IN_APP
});

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

class Thumbnail {
  int? id;
  Extname? extname;
  Type? type;
  String? path;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? url;

  Thumbnail({
    this.id,
    this.extname,
    this.type,
    this.path,
    this.createdAt,
    this.updatedAt,
    this.url,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        id: json["id"],
        extname: extnameValues.map[json["extname"]]!,
        type: typeValues.map[json["type"]]!,
        path: json["path"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "extname": extnameValues.reverse[extname],
        "type": typeValues.reverse[type],
        "path": path,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "url": url,
      };
}

enum Extname { JPEG, JPG, PNG }

final extnameValues =
    EnumValues({"jpeg": Extname.JPEG, "jpg": Extname.JPG, "png": Extname.PNG});

enum Type { IMAGE }

final typeValues = EnumValues({"image": Type.IMAGE});

class Meta {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  int? firstPage;
  String? firstPageUrl;
  String? lastPageUrl;
  String? nextPageUrl;
  String? previousPageUrl;

  Meta({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.firstPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.previousPageUrl,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json["total"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        firstPage: json["first_page"],
        firstPageUrl: json["first_page_url"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        previousPageUrl: json["previous_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "per_page": perPage,
        "current_page": currentPage,
        "last_page": lastPage,
        "first_page": firstPage,
        "first_page_url": firstPageUrl,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "previous_page_url": previousPageUrl,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
