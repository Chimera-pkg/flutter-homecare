class ProfileDistributor {
  int? id;
  int? creatorId;
  String? email;
  String? username;
  String? description;
  bool? isVerified;
  String? role;
  String? createdAt;
  String? updatedAt;
  Distributor? distributor;

  ProfileDistributor(
      {this.id,
      this.creatorId,
      this.email,
      this.username,
      this.description,
      this.isVerified,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.distributor});

  ProfileDistributor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['creator_id'];
    email = json['email'];
    username = json['username'];
    description = json['description'];
    isVerified = json['is_verified'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distributor = json['distributor'] != null
        ? new Distributor.fromJson(json['distributor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['creator_id'] = this.creatorId;
    data['email'] = this.email;
    data['username'] = this.username;
    data['description'] = this.description;
    data['is_verified'] = this.isVerified;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.distributor != null) {
      data['distributor'] = this.distributor!.toJson();
    }
    return data;
  }
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
  String? createdAt;
  String? updatedAt;
  Logo? logo;
  Country? country;
  Logo? profileFile;
  List<DistributorCategoryTags>? distributorCategoryTags;

  Distributor(
      {this.id,
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
      this.logo,
      this.country,
      this.profileFile,
      this.distributorCategoryTags});

  Distributor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    address = json['address'];
    website = json['website'];
    overview = json['overview'];
    about = json['about'];
    userId = json['user_id'];
    contactName = json['contact_name'];
    contactEmail = json['contact_email'];
    contactMobile = json['contact_mobile'];
    contactUrl = json['contact_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    profileFile = json['profile_file'] != null
        ? new Logo.fromJson(json['profile_file'])
        : null;
    if (json['distributor_category_tags'] != null) {
      distributorCategoryTags = <DistributorCategoryTags>[];
      json['distributor_category_tags'].forEach((v) {
        distributorCategoryTags!.add(new DistributorCategoryTags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['address'] = this.address;
    data['website'] = this.website;
    data['overview'] = this.overview;
    data['about'] = this.about;
    data['user_id'] = this.userId;
    data['contact_name'] = this.contactName;
    data['contact_email'] = this.contactEmail;
    data['contact_mobile'] = this.contactMobile;
    data['contact_url'] = this.contactUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.profileFile != null) {
      data['profile_file'] = this.profileFile!.toJson();
    }
    if (this.distributorCategoryTags != null) {
      data['distributor_category_tags'] =
          this.distributorCategoryTags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Logo {
  int? id;
  String? extname;
  String? type;
  String? path;
  String? createdAt;
  String? updatedAt;
  String? url;

  Logo(
      {this.id,
      this.extname,
      this.type,
      this.path,
      this.createdAt,
      this.updatedAt,
      this.url});

  Logo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    extname = json['extname'];
    type = json['type'];
    path = json['path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['extname'] = this.extname;
    data['type'] = this.type;
    data['path'] = this.path;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['url'] = this.url;
    return data;
  }
}

class Country {
  int? id;
  String? name;
  String? iso;
  String? phoneCode;
  String? createdAt;
  String? updatedAt;

  Country(
      {this.id,
      this.name,
      this.iso,
      this.phoneCode,
      this.createdAt,
      this.updatedAt});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iso = json['iso'];
    phoneCode = json['phone_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['iso'] = this.iso;
    data['phone_code'] = this.phoneCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class DistributorCategoryTags {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  DistributorCategoryTags({this.id, this.name, this.createdAt, this.updatedAt});

  DistributorCategoryTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
