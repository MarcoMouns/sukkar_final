class ArticleDetailCategory {
  ArticlesBean articles;

  ArticleDetailCategory({this.articles});

  ArticleDetailCategory.fromJson(Map<String, dynamic> json) {    
    this.articles = json['articles'] != null ? ArticlesBean.fromJson(json['articles']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articles != null) {
      data['articles'] = this.articles.toJson();
    }
    return data;
  }

}

class ArticlesBean {
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

  ArticlesBean({this.firstPageUrl, this.lastPageUrl, this.nextPageUrl, this.path, this.prevPageUrl, this.currentPage, this.from, this.lastPage, this.perPage, this.to, this.total, this.data});

  ArticlesBean.fromJson(Map<String, dynamic> json) {    
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
  String text;
  String image;
  String file;
  String video;
  String startDate;
  String createdAt;
  String updatedAt;
  int id;
  int categoryId;

  DataListBean({this.name, this.text, this.image, this.file, this.video, this.startDate, this.createdAt, this.updatedAt, this.id, this.categoryId});

  DataListBean.fromJson(Map<String, dynamic> json) {    
    this.name = json['name'];
    this.text = json['text'];
    this.image = json['image'];
    this.file = json['file'];
    this.video = json['video'];
    this.startDate = json['start_date'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.id = json['id'];
    this.categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['text'] = this.text;
    data['image'] = this.image;
    data['file'] = this.file;
    data['video'] = this.video;
    data['start_date'] = this.startDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    return data;
  }
}
