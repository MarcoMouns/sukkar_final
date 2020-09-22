class ArticleDetails {
  ArticleBean article;

  ArticleDetails({this.article});

  ArticleDetails.fromJson(Map<String, dynamic> json) {    
    this.article = json['article'] != null ? ArticleBean.fromJson(json['article']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.article != null) {
      data['article'] = this.article.toJson();
    }
    return data;
  }

}

class ArticleBean {
  String name;
  String text;
  String image;
  String file;
  String video;
  String startDate;
  String createdAt;
  String updatedAt;
  String dynamicLink;
  int id;
  int categoryId;

  ArticleBean(
      {this.dynamicLink,
      this.name,
      this.text,
      this.image,
      this.file,
      this.video,
      this.startDate,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.categoryId});

  ArticleBean.fromJson(Map<String, dynamic> json) {
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
    this.dynamicLink = json['dynamic_link'];
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
    data['dynamic_link'] = this.dynamicLink;
    return data;
  }
}
