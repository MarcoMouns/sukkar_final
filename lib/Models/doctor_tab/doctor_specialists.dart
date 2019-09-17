class DoctorSpecialists {
  DoctorsBean doctors;

  DoctorSpecialists({this.doctors});

  DoctorSpecialists.fromJson(Map<String, dynamic> json) {    
    this.doctors = json['doctors'] != null ? DoctorsBean.fromJson(json['doctors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctors != null) {
      data['doctors'] = this.doctors.toJson();
    }
    return data;
  }

}

class DoctorsBean {
  String firstPageUrl;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  String prevPageUrl;
  int currentPage;
  int from;
  int lastPage;
  int perPage;
  int to;
  int total;
  List<DataListBean> data;

  DoctorsBean({this.firstPageUrl, this.lastPageUrl, this.nextPageUrl, this.path, this.prevPageUrl, this.currentPage, this.from, this.lastPage, this.perPage, this.to, this.total, this.data});

  DoctorsBean.fromJson(Map<String, dynamic> json) {    
    this.firstPageUrl = json['first_page_url'];
    this.lastPageUrl = json['last_page_url'];
    this.nextPageUrl = json['next_page_url'];
    this.path = json['path'];
    this.prevPageUrl = json['prev_page_url'];
    this.currentPage = json['current_page'];
    this.from = json['from'];
    this.lastPage = json['last_page'];
    this.perPage = json['per_page'];
    this.to = json['to'];
    this.total = json['total'];
    this.data = (json['data'] as List)!=null?(json['data'] as List).map((i) => DataListBean.fromJson(i)).toList():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_page_url'] = this.firstPageUrl;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['prev_page_url'] = this.prevPageUrl;
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    data['data'] = this.data != null?this.data.map((i) => i.toJson()).toList():null;
    return data;
  }
}

class DataListBean {
  String name;
  String email;
  String phone;
  String image;
  String tokenId;
  String gender;
  String hight;
  String birthDate;
  String provider;
  String providerId;
  String deletedAt;
  String createdAt;
  String updatedAt;
  int id;
  int generatedCode;
  int type;
  int state;
  int specialistId;
  int rating;
  SpecialistBean specialist;
  List<DoctorCvListBean> doctorCv;
  List<PlacesListBean> places;

  DataListBean({this.name, this.email, this.phone, this.image, this.tokenId, this.gender, this.hight, this.birthDate, this.provider, this.providerId, this.deletedAt, this.createdAt, this.updatedAt, this.id, this.generatedCode, this.type, this.state, this.specialistId, this.rating, this.specialist, this.doctorCv, this.places});

  DataListBean.fromJson(Map<String, dynamic> json) {    
    this.name = json['name'];
    this.email = json['email'];
    this.phone = json['phone'];
    this.image = json['image'];
    this.tokenId = json['token_id'];
    this.gender = json['gender'];
    this.hight = json['hight'];
    this.birthDate = json['birth_date'];
    this.provider = json['provider'];
    this.providerId = json['provider_id'];
    this.deletedAt = json['deleted_at'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.id = json['id'];
    this.generatedCode = json['generated_code'];
    this.type = json['type'];
    this.state = json['state'];
    this.specialistId = json['specialist_id'];
    this.rating = json['rating'];
    this.specialist = json['specialist'] != null ? SpecialistBean.fromJson(json['specialist']) : null;
    this.doctorCv = (json['doctor_cv'] as List)!=null?(json['doctor_cv'] as List).map((i) => DoctorCvListBean.fromJson(i)).toList():null;
    this.places = (json['places'] as List)!=null?(json['places'] as List).map((i) => PlacesListBean.fromJson(i)).toList():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['token_id'] = this.tokenId;
    data['gender'] = this.gender;
    data['hight'] = this.hight;
    data['birth_date'] = this.birthDate;
    data['provider'] = this.provider;
    data['provider_id'] = this.providerId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    data['generated_code'] = this.generatedCode;
    data['type'] = this.type;
    data['state'] = this.state;
    data['specialist_id'] = this.specialistId;
    data['rating'] = this.rating;
    if (this.specialist != null) {
      data['specialist'] = this.specialist.toJson();
    }
    data['doctor_cv'] = this.doctorCv != null?this.doctorCv.map((i) => i.toJson()).toList():null;
    data['places'] = this.places != null?this.places.map((i) => i.toJson()).toList():null;
    return data;
  }
}

class SpecialistBean {
  String titleAr;
  String titleEn;
  String createdAt;
  String updatedAt;
  int id;

  SpecialistBean({this.titleAr, this.titleEn, this.createdAt, this.updatedAt, this.id});

  SpecialistBean.fromJson(Map<String, dynamic> json) {    
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

class DoctorCvListBean {
  String brief;
  String workFrom;
  String createdAt;
  String updatedAt;
  int id;
  int userId;
  int placeId;

  DoctorCvListBean({this.brief, this.workFrom, this.createdAt, this.updatedAt, this.id, this.userId, this.placeId});

  DoctorCvListBean.fromJson(Map<String, dynamic> json) {    
    this.brief = json['brief'];
    this.workFrom = json['work_from'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.id = json['id'];
    this.userId = json['user_id'];
    this.placeId = json['place_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brief'] = this.brief;
    data['work_from'] = this.workFrom;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['place_id'] = this.placeId;
    return data;
  }
}

class PlacesListBean {
  String title;
  String createdAt;
  String updatedAt;
  int id;
  int userId;

  PlacesListBean({this.title, this.createdAt, this.updatedAt, this.id, this.userId});

  PlacesListBean.fromJson(Map<String, dynamic> json) {    
    this.title = json['title'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.id = json['id'];
    this.userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    return data;
  }
}
