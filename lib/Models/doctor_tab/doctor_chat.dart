class DoctorChat {
  ChatBean chat;

  DoctorChat({this.chat});

  DoctorChat.fromJson(Map<String, dynamic> json) {
    this.chat = json['chat'] != null ? ChatBean.fromJson(json['chat']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chat != null) {
      data['chat'] = this.chat.toJson();
    }
    return data;
  }
}

class ChatBean {
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

  ChatBean(
      {this.firstPageUrl,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.prevPageUrl,
      this.currentPage,
      this.from,
      this.lastPage,
      this.perPage,
      this.to,
      this.total,
      this.data});

  ChatBean.fromJson(Map<String, dynamic> json) {
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
    this.data = (json['data'] as List) != null
        ? (json['data'] as List).map((i) => DataListBean.fromJson(i)).toList()
        : null;
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
    data['data'] =
        this.data != null ? this.data.map((i) => i.toJson()).toList() : null;
    return data;
  }
}

class DataListBean {
  String body;
  String createdAt;
  String updatedAt;
  int id;
  int userSent;
  int userRecieve;

  DataListBean(
      {this.body,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.userSent,
      this.userRecieve});

  DataListBean.fromJson(Map<String, dynamic> json) {
    this.body = json['body'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.id = json['id'];
    this.userSent = json['user_sent'];
    this.userRecieve = json['user_recieve'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    data['user_sent'] = this.userSent;
    data['user_recieve'] = this.userRecieve;
    return data;
  }
}
