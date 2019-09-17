class MealModel {
  List<Eatcategories> eatcategories;

  MealModel({this.eatcategories});

  MealModel.fromJson(Map<String, dynamic> json) {
    if (json['eatcategories'] != null) {
      eatcategories = new List<Eatcategories>();
      json['eatcategories'].forEach((v) {
        eatcategories.add(new Eatcategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eatcategories != null) {
      data['eatcategories'] =
          this.eatcategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Eatcategories {
  int id;
  String titleAr;
  String titleEn;
  String image;
  String createdAt;
  String updatedAt;

  Eatcategories(
      {this.id,
      this.titleAr,
      this.titleEn,
      this.image,
      this.createdAt,
      this.updatedAt});

  Eatcategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleAr = json['title_ar'];
    titleEn = json['title_en'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title_ar'] = this.titleAr;
    data['title_en'] = this.titleEn;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}