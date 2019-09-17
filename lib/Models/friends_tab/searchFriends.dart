class SearchFriends {
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
  int id;
  int gender;
  int generatedCode;
  int type;
  int state;
  int searchCode;
  int rating;

  SearchFriends({this.name, this.email, this.phone, this.image, this.tokenId, this.hight, this.birthDate, this.provider, this.providerId, this.specialistId, this.deletedAt, this.createdAt, this.updatedAt, this.id, this.gender, this.generatedCode, this.type, this.state, this.searchCode, this.rating});

  SearchFriends.fromJson(Map<String, dynamic> json) {    
    this.name = json['name'];
    this.email = json['email'];
    this.phone = json['phone'];
    this.image = json['image'];
    this.tokenId = json['token_id'];
    this.hight = json['hight'];
    this.birthDate = json['birth_date'];
    this.provider = json['provider'];
    this.providerId = json['provider_id'];
    this.specialistId = json['specialist_id'];
    this.deletedAt = json['deleted_at'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.id = json['id'];
    this.gender = json['gender'];
    this.generatedCode = json['generated_code'];
    this.type = json['type'];
    this.state = json['state'];
    this.searchCode = json['search_code'];
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
    data['id'] = this.id;
    data['gender'] = this.gender;
    data['generated_code'] = this.generatedCode;
    data['type'] = this.type;
    data['state'] = this.state;
    data['search_code'] = this.searchCode;
    data['rating'] = this.rating;
    return data;
  }

}
