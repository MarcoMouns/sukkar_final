class Specialists {
  List<SpecialistsListBean> specialists;

  Specialists({this.specialists});

  Specialists.fromJson(Map<String, dynamic> json) {    
    this.specialists = (json['specialists'] as List)!=null?(json['specialists'] as List).map((i) => SpecialistsListBean.fromJson(i)).toList():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specialists'] = this.specialists != null?this.specialists.map((i) => i.toJson()).toList():null;
    return data;
  }

}

class SpecialistsListBean {
  String titleAr;
  String titleEn;
  String createdAt;
  String updatedAt;
  int id;

  SpecialistsListBean({this.titleAr, this.titleEn, this.createdAt, this.updatedAt, this.id});

  SpecialistsListBean.fromJson(Map<String, dynamic> json) {    
    this.titleAr = json['title_ar'];
    this.titleEn = json['title_en'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title_ar'] = this.titleAr;
    data['title_en'] = this.titleEn;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}
