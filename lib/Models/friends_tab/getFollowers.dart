class GetFollowers {
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

  GetFollowers({this.firstPageUrl, this.lastPageUrl, this.nextPageUrl, this.path, this.prevPageUrl, this.currentPage, this.from, this.lastPage, this.perPage, this.to, this.total, this.data});

  GetFollowers.fromJson(Map<String, dynamic> json) {
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
  int hight;
  String birthDate;
  String provider;
  String providerId;
  int specialistId;
  String deletedAt;
  String createdAt;
  String updatedAt;
  String searchCode;
  int id;
  int gender;
  int generatedCode;
  int type;
  int state;
  int rating;

  DataListBean({this.name, this.email, this.phone, this.image, this.tokenId, this.hight, this.birthDate, this.provider, this.providerId, this.specialistId, this.deletedAt, this.createdAt, this.updatedAt, this.searchCode, this.id, this.gender, this.generatedCode, this.type, this.state, this.rating});

  DataListBean.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.email = json['email'];
    this.phone = json['phone'];
    this.image = json['image'];
    this.tokenId = json['token_id'];
    this.hight = json['hight'];
    this.birthDate = json['birth_date'];
    this.provider = json['provider'];
    this.providerId = json['provider_id'];
    this.specialistId = json['specialist_id'] ?? 0;
    this.deletedAt = json['deleted_at'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.searchCode = json['search_code'];
    this.id = json['id'];
    this.gender = json['gender'];
    this.generatedCode = json['generated_code'];
    this.type = json['type'];
    this.state = json['state'];
    this.rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['token_id'] = this.tokenId;
    data['hight'] = this.hight;
    data['birth_date'] = this.birthDate;
    data['provider'] = this.provider;
    data['provider_id'] = this.providerId;
    data['specialist_id'] = this.specialistId ?? 0;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['search_code'] = this.searchCode;
    data['id'] = this.id;
    data['gender'] = this.gender;
    data['generated_code'] = this.generatedCode;
    data['type'] = this.type;
    data['state'] = this.state;
    data['rating'] = this.rating;
    return data;
  }
}