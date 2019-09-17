class Test {
  String success;
  String message;
  List<DataListBean> data;

  Test({this.success, this.message, this.data});

  Test.fromJson(Map<String, dynamic> json) {    
    this.success = json['success'];
    this.message = json['message'];
    this.data = (json['data'] as List)!=null?(json['data'] as List).map((i) => DataListBean.fromJson(i)).toList():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data != null?this.data.map((i) => i.toJson()).toList():null;
    return data;
  }

}

class DataListBean {
  String customersGender;
  String customersFirstname;
  String customersLastname;
  String customersDob;
  String email;
  String userName;
  String customersTelephone;
  String customersFax;
  String password;
  String customersNewsletter;
  String fbId;
  String googleId;
  String customersPicture;
  String rememberToken;
  int customersId;
  int customersDefaultAddressId;
  int isActive;
  int createdAt;
  int updatedAt;
  int isSeen;
  List<LikedProductsListBean> likedProducts;

  DataListBean({this.customersGender, this.customersFirstname, this.customersLastname, this.customersDob, this.email, this.userName, this.customersTelephone, this.customersFax, this.password, this.customersNewsletter, this.fbId, this.googleId, this.customersPicture, this.rememberToken, this.customersId, this.customersDefaultAddressId, this.isActive, this.createdAt, this.updatedAt, this.isSeen, this.likedProducts});

  DataListBean.fromJson(Map<String, dynamic> json) {    
    this.customersGender = json['customers_gender'];
    this.customersFirstname = json['customers_firstname'];
    this.customersLastname = json['customers_lastname'];
    this.customersDob = json['customers_dob'];
    this.email = json['email'];
    this.userName = json['user_name'];
    this.customersTelephone = json['customers_telephone'];
    this.customersFax = json['customers_fax'];
    this.password = json['password'];
    this.customersNewsletter = json['customers_newsletter'];
    this.fbId = json['fb_id'];
    this.googleId = json['google_id'];
    this.customersPicture = json['customers_picture'];
    this.rememberToken = json['remember_token'];
    this.customersId = json['customers_id'];
    this.customersDefaultAddressId = json['customers_default_address_id'];
    this.isActive = json['isActive'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.isSeen = json['is_seen'];
    this.likedProducts = (json['liked_products'] as List)!=null?(json['liked_products'] as List).map((i) => LikedProductsListBean.fromJson(i)).toList():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customers_gender'] = this.customersGender;
    data['customers_firstname'] = this.customersFirstname;
    data['customers_lastname'] = this.customersLastname;
    data['customers_dob'] = this.customersDob;
    data['email'] = this.email;
    data['user_name'] = this.userName;
    data['customers_telephone'] = this.customersTelephone;
    data['customers_fax'] = this.customersFax;
    data['password'] = this.password;
    data['customers_newsletter'] = this.customersNewsletter;
    data['fb_id'] = this.fbId;
    data['google_id'] = this.googleId;
    data['customers_picture'] = this.customersPicture;
    data['remember_token'] = this.rememberToken;
    data['customers_id'] = this.customersId;
    data['customers_default_address_id'] = this.customersDefaultAddressId;
    data['isActive'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_seen'] = this.isSeen;
    data['liked_products'] = this.likedProducts != null?this.likedProducts.map((i) => i.toJson()).toList():null;
    return data;
  }
}

class LikedProductsListBean {
  int productsId;

  LikedProductsListBean({this.productsId});

  LikedProductsListBean.fromJson(Map<String, dynamic> json) {    
    this.productsId = json['products_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['products_id'] = this.productsId;
    return data;
  }
}
