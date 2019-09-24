class HomeModel {
  MeasurementsBean measurements;
  List<BannersListBean> banners;
  List<WeekListBean> week;

  HomeModel({this.measurements, this.banners, this.week});

  HomeModel.fromJson(Map<String, dynamic> json) {    
    this.measurements = json['measurements'] != null ? MeasurementsBean.fromJson(json['measurements']) : null;
    this.banners = (json['banners'] as List)!=null?(json['banners'] as List).map((i) => BannersListBean.fromJson(i)).toList():null;
    this.week = (json['week'] as List)!=null?(json['week'] as List).map((i) => WeekListBean.fromJson(i)).toList():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.measurements != null) {
      data['measurements'] = this.measurements.toJson();
    }
    data['banners'] = this.banners != null?this.banners.map((i) => i.toJson()).toList():null;
    data['week'] = this.week != null?this.week.map((i) => i.toJson()).toList():null;
    return data;
  }

}

class MeasurementsBean {
  int distance;
  int steps;
  int calories;
  int sugar;

  MeasurementsBean({this.distance, this.steps, this.calories, this.sugar});

  MeasurementsBean.fromJson(Map<String, dynamic> json) {    
    this.distance = json['distance'];
    this.steps = json['steps'];
    this.calories = json['calories'];
    this.sugar = json['sugar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['steps'] = this.steps;
    data['calories'] = this.calories;
    data['sugar'] = this.sugar;
    return data;
  }
}

class BannersListBean {
  String type;
  String image;
  String created;
  String updated;
  String name;
  String text;
  String file;
  String video;
  int id;
  int categoryId;

  BannersListBean({this.type, this.image, this.created, this.updated, this.name, this.text, this.file, this.video, this.id, this.categoryId});

  BannersListBean.fromJson(Map<String, dynamic> json) {    
    this.type = json['type'];
    this.image = json['image'];
    this.created = json['createdar'];
    this.updated = json['updated'];
    this.name = json['name'];
    this.text = json['text'];
    this.file = json['file'];
    this.video = json['video'];
    this.id = json['id'];
    this.categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['image'] = this.image;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['name'] = this.name;
    data['text'] = this.text;
    data['file'] = this.file;
    data['video'] = this.video;
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    return data;
  }
}

class WeekListBean {
  String date;
  String day;
  var sugar;

  WeekListBean({this.date, this.day, this.sugar});

  WeekListBean.fromJson(Map<String, dynamic> json) {    
    this.date = json['date'];
    this.day = json['day'];
    this.sugar = json['sugar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day'] = this.day;
    data['sugar'] = this.sugar;
    return data;
  }
}
