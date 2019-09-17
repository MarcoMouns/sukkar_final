class UserFoodsModel {
  List<Foods> foods;

  UserFoodsModel({this.foods});

  UserFoodsModel.fromJson(Map<String, dynamic> json) {
    if (json['foods'] != null) {
      foods = new List<Foods>();
      json['foods'].forEach((v) {
        foods.add(new Foods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.foods != null) {
      data['foods'] = this.foods.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Foods {
  int id;
  String titleAr;
  String titleEn;
  int calories;
  int userId;
  int isselected;
  String createdAt;
  String updatedAt;

  Foods(
      {this.id,
      this.titleAr,
      this.titleEn,
      this.calories,
      this.userId,
      this.isselected,
      this.createdAt,
      this.updatedAt});

  Foods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleAr = json['title_ar'];
    titleEn = json['title_en'];
    calories = json['calories'];
    userId = json['user_id'];
    isselected = json['isselected'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title_ar'] = this.titleAr;
    data['title_en'] = this.titleEn;
    data['calories'] = this.calories;
    data['user_id'] = this.userId;
    data['isselected'] = this.isselected;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}