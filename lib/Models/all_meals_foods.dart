class AllMealsFoodsModel {
  List<UserFoods> userFoods;

  AllMealsFoodsModel({this.userFoods});

  AllMealsFoodsModel.fromJson(Map<String, dynamic> json) {
    if (json['userFoods'] != null) {
      userFoods = new List<UserFoods>();
      json['userFoods'].forEach((v) {
        userFoods.add(new UserFoods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userFoods != null) {
      data['userFoods'] = this.userFoods.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserFoods {
  int id;
  String titleAr;
  String titleEn;
  int calories;
  int eatCategoryId;
  int userId;
  int isselected;
  String createdAt;
  String updatedAt;
  Categories eatcategories;

  UserFoods(
      {this.id,
      this.titleAr,
      this.titleEn,
      this.calories,
      this.eatCategoryId,
      this.userId,
      this.isselected,
      this.createdAt,
      this.updatedAt,
      this.eatcategories});

  UserFoods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleAr = json['title_ar'];
    titleEn = json['title_en'];
    calories = json['calories'];
    eatCategoryId = json['eat_category_id'];
    userId = json['user_id'];
    isselected = json['isselected'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    eatcategories = json['eatcategories'] != null
        ? new Categories.fromJson(json['eatcategories'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title_ar'] = this.titleAr;
    data['title_en'] = this.titleEn;
    data['calories'] = this.calories;
    data['eat_category_id'] = this.eatCategoryId;
    data['user_id'] = this.userId;
    data['isselected'] = this.isselected;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.eatcategories != null) {
      data['eatcategories'] = this.eatcategories.toJson();
    }
    return data;
  }
}

class Categories {
  int id;
  String titleAr;
  String titleEn;
  String image;
  String createdAt;
  String updatedAt;

  Categories(
      {this.id,
      this.titleAr,
      this.titleEn,
      this.image,
      this.createdAt,
      this.updatedAt});

  Categories.fromJson(Map<String, dynamic> json) {
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