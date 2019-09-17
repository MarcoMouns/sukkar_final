class ArticleCategory {
  ArticleCategoryBean articleCategory;

  ArticleCategory({this.articleCategory});

  ArticleCategory.fromJson(Map<String, dynamic> json) {    
    this.articleCategory = json['article_category'] != null ? ArticleCategoryBean.fromJson(json['article_category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articleCategory != null) {
      data['article_category'] = this.articleCategory.toJson();
    }
    return data;
  }

}

class ArticleCategoryBean {
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

  ArticleCategoryBean({this.firstPageUrl, this.lastPageUrl, this.nextPageUrl, this.path, this.prevPageUrl, this.currentPage, this.from, this.lastPage, this.perPage, this.to, this.total, this.data});

  ArticleCategoryBean.fromJson(Map<String, dynamic> json) {    
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
  String titleAr;
  String titleEn;
  String image;
  String createdAt;
  String updatedAt;
  int id;

  DataListBean({this.titleAr, this.titleEn, this.image, this.createdAt, this.updatedAt, this.id});

  DataListBean.fromJson(Map<String, dynamic> json) {    
    this.titleAr = json['title_ar'];
    this.titleEn = json['title_en'];
    this.image = json['image'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title_ar'] = this.titleAr;
    data['title_en'] = this.titleEn;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}
