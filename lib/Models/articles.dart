class Articles {
  List<AdvertiseListBean> advertise;
  List<ArticlesListBean> articles;

  Articles({this.advertise, this.articles});

  Articles.fromJson(Map<String, dynamic> json) {
    this.advertise = (json['advertise'] as List)!=null?(json['advertise'] as List).map((i) => AdvertiseListBean.fromJson(i)).toList():null;
    this.articles = (json['articles'] as List)!=null?(json['articles'] as List).map((i) => ArticlesListBean.fromJson(i)).toList():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['advertise'] = this.advertise != null?this.advertise.map((i) => i.toJson()).toList():null;
    data['articles'] = this.articles != null?this.articles.map((i) => i.toJson()).toList():null;
    return data;
  }

}

class AdvertiseListBean {
  String image;
  String createdAt;
  String updatedAr;
  int id;

  AdvertiseListBean({this.image, this.createdAt, this.updatedAr, this.id});

  AdvertiseListBean.fromJson(Map<String, dynamic> json) {
    this.image = json['image'];
    this.createdAt = json['created_at'];
    this.updatedAr = json['updated_ar'];
    this.id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_ar'] = this.updatedAr;
    data['id'] = this.id;
    return data;
  }
}

class ArticlesListBean {
  String name;
  String text;
  String image;
  String startDate;
  String createdAt;
  String updatedAt;
  int id;

  ArticlesListBean({this.name, this.text, this.image, this.startDate, this.createdAt, this.updatedAt, this.id});

  ArticlesListBean.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.text = json['text'];
    this.image = json['image'];
    this.startDate = json['start_date'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['text'] = this.text;
    data['image'] = this.image;
    data['start_date'] = this.startDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}
