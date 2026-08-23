class ProductModel {
  int? id;
  String? title;
  String? slug;
  int? price;
  String? description;
  Category? category;
  List<String>? images;
  String? creationAt;
  String? updatedAt;

  ProductModel({
    this.id,
    this.title,
    this.slug,
    this.price,
    this.description,
    this.category,
    this.images,
    this.creationAt,
    this.updatedAt,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    slug = json["slug"];
    price = json["price"];
    description = json["description"];
    category = json["category"] == null
        ? null
        : Category.fromJson(json["category"]);
    images = json["images"] == null ? null : List<String>.from(json["images"]);
    creationAt = json["creationAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["slug"] = slug;
    _data["price"] = price;
    _data["description"] = description;
    if (category != null) {
      _data["category"] = category?.toJson();
    }
    if (images != null) {
      _data["images"] = images;
    }
    _data["creationAt"] = creationAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}

class Category {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? creationAt;
  String? updatedAt;

  Category({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.creationAt,
    this.updatedAt,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    slug = json["slug"];
    image = json["image"];
    creationAt = json["creationAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["slug"] = slug;
    _data["image"] = image;
    _data["creationAt"] = creationAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}
