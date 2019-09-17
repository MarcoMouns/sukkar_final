class GetFollowing {
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
  List<DataListBean2> data;

  GetFollowing({this.firstPageUrl, this.lastPageUrl, this.nextPageUrl, this.path, this.prevPageUrl, this.currentPage, this.from, this.lastPage, this.perPage, this.to, this.total, this.data});

  GetFollowing.fromJson(Map<String, dynamic> json) {
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
    this.data = (json['data'] as List)!=null?(json['data'] as List).map((i) => DataListBean2.fromJson(i)).toList():null;
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

class DataListBean2 {
  String name;
  String email;
  String phone;
  String image;
  String tokenId;
  String hight;
  String birthDate;
  String provider;
  String providerId;
  String specialistId;
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

  DataListBean2({this.name, this.email, this.phone, this.image, this.tokenId, this.hight, this.birthDate, this.provider, this.providerId, this.specialistId, this.deletedAt, this.createdAt, this.updatedAt, this.searchCode, this.id, this.gender, this.generatedCode, this.type, this.state, this.rating});

  DataListBean2.fromJson(Map<String, dynamic> json) {
    this.name = json['name'].toString();
    this.email = json['email'].toString();
    this.phone = json['phone'].toString();
    this.image = json['image'].toString();
    this.tokenId = json['token_id'].toString();
    this.hight = json['hight'].toString();
    this.birthDate = json['birth_date'].toString();
    this.provider = json['provider'].toString();
    this.providerId = json['provider_id'].toString();
    this.specialistId = json['specialist_id'].toString();
    this.deletedAt = json['deleted_at'].toString();
    this.createdAt = json['created_at'].toString();
    this.updatedAt = json['updated_at'].toString();
    this.searchCode = json['search_code'].toString();
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
    data['specialist_id'] = this.specialistId;
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
