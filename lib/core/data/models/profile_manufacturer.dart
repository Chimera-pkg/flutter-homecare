class ProfileManufacturer {
  int? id;
  int? creatorId;
  String? email;
  String? username;
  String? description;
  bool? isVerified;
  String? role;
  String? createdAt;
  String? updatedAt;
  Manufacturer? manufacturer;

  ProfileManufacturer(
      {this.id,
      this.creatorId,
      this.email,
      this.username,
      this.description,
      this.isVerified,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.manufacturer});

  ProfileManufacturer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['creator_id'];
    email = json['email'];
    username = json['username'];
    description = json['description'];
    isVerified = json['is_verified'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    manufacturer = json['manufacturer'] != null
        ? new Manufacturer.fromJson(json['manufacturer'])
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
    if (this.manufacturer != null) {
      data['manufacturer'] = this.manufacturer!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'ProfileManufacturer(id: $id, creatorId: $creatorId, email: $email, username: $username, description: $description, isVerified: $isVerified, role: $role, createdAt: $createdAt, updatedAt: $updatedAt, manufacturer: $manufacturer)';
  }
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
  String? createdAt;
  String? updatedAt;
  Logo? logo;
  IndustryCategory? industryCategory;
  Country? country;
  Logo? profileFile;
  CategoryOne? categoryOne;
  CategoryOne? categoryTwo;
  IndustryCategory? categoryTwoService;
  IndustryCategory? categoryOneService;

  Manufacturer(
      {this.id,
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
      this.logo,
      this.industryCategory,
      this.country,
      this.profileFile,
      this.categoryOne,
      this.categoryTwo,
      this.categoryTwoService,
      this.categoryOneService});

  Manufacturer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    picName = json['pic_name'];
    description = json['description'];
    address = json['address'];
    website = json['website'];
    video = json['video'];
    about = json['about'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
    industryCategory = json['industry_category'] != null
        ? new IndustryCategory.fromJson(json['industry_category'])
        : null;
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    profileFile = json['profile_file'] != null
        ? new Logo.fromJson(json['profile_file'])
        : null;
    categoryOne = json['category_one'] != null
        ? new CategoryOne.fromJson(json['category_one'])
        : null;
    categoryTwo = json['category_two'] != null
        ? new CategoryOne.fromJson(json['category_two'])
        : null;
    categoryTwoService = json['category_two_service'] != null
        ? new IndustryCategory.fromJson(json['category_two_service'])
        : null;
    categoryOneService = json['category_one_service'] != null
        ? new IndustryCategory.fromJson(json['category_one_service'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pic_name'] = this.picName;
    data['description'] = this.description;
    data['address'] = this.address;
    data['website'] = this.website;
    data['video'] = this.video;
    data['about'] = this.about;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    if (this.industryCategory != null) {
      data['industry_category'] = this.industryCategory!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.profileFile != null) {
      data['profile_file'] = this.profileFile!.toJson();
    }
    if (this.categoryOne != null) {
      data['category_one'] = this.categoryOne!.toJson();
    }
    if (this.categoryTwo != null) {
      data['category_two'] = this.categoryTwo!.toJson();
    }
    if (this.categoryTwoService != null) {
      data['category_two_service'] = this.categoryTwoService!.toJson();
    }
    if (this.categoryOneService != null) {
      data['category_one_service'] = this.categoryOneService!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Manufacturer(id: $id, name: $name, picName: $picName, description: $description, address: $address, website: $website, video: $video, about: $about, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, logo: $logo, industryCategory: $industryCategory, country: $country, profileFile: $profileFile, categoryOne: $categoryOne, categoryTwo: $categoryTwo, categoryTwoService: $categoryTwoService, categoryOneService: $categoryOneService)';
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

class IndustryCategory {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  IndustryCategory({this.id, this.name, this.createdAt, this.updatedAt});

  IndustryCategory.fromJson(Map<String, dynamic> json) {
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

class CategoryOne {
  int? id;
  String? name;
  String? description;
  int? categoryId;
  String? createdAt;
  String? updatedAt;

  CategoryOne(
      {this.id,
      this.name,
      this.description,
      this.categoryId,
      this.createdAt,
      this.updatedAt});

  CategoryOne.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
