class SpecialityDoc{
  int id;
  String titleAr;
  String titleEn;

  SpecialityDoc({this.id, this.titleAr, this.titleEn});

  factory SpecialityDoc.fromJson(Map<String,dynamic> json){
    return SpecialityDoc(
      id: json["id"],
      titleAr: json["title_ar"],
      titleEn: json["title_en"],
    );
  }
}