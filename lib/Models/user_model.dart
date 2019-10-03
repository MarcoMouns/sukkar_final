class UserModel {
  String accessToken;
  String tokenType;
  int expiresIn;
  User user;

  UserModel({this.accessToken, this.tokenType, this.expiresIn, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  int search_code;
  String name;
  String email;
  String phone;
  String image;
  String tokenId;
  String fuid;
  int gender;
  int hight;
  int weight;
  int average_calorie;
  int generatedCode;
  String birthDate;
  int type;
  int state;
  String deletedAt;
  String createdAt;
  String updatedAt;

  User(
      {this.id,
        this.search_code,
      this.name,
      this.email,
      this.phone,
      this.image,
      this.tokenId,
        this.fuid,
      this.gender,
      this.hight,
        this.weight,
        this.average_calorie,
      this.generatedCode,
      this.birthDate,
      this.type,
      this.state,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    search_code = json['search_code'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    tokenId = json['token_id'];
    fuid = json['fuid'];
    gender = json['gender'];
    hight = json['hight'];
    weight= json['weight'];
    average_calorie=json['average_calorie'];
    generatedCode = json['generated_code'];
    birthDate = json['birth_date'];
    type = json['type'];
    state = json['state'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['search_code']= this.search_code;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['fuid'] = this.fuid;
    data['image'] = this.image;
    data['token_id'] = this.tokenId;
    data['gender'] = this.gender;
    data['hight'] = this.hight;
    data['weight']= this.weight;
    data['fuid']= this.fuid;
    data['average_calorie']=this.average_calorie;
    data['generated_code'] = this.generatedCode;
    data['birth_date'] = this.birthDate;
    data['type'] = this.type;
    data['state'] = this.state;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}