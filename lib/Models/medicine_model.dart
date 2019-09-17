class MedicineModel {
  List<Medicines> medicines;

  MedicineModel({this.medicines});

  MedicineModel.fromJson(List<dynamic> json) {
    if (json != null) {
      medicines = new List<Medicines>();
      json.forEach((v) {
        medicines.add(new Medicines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicines != null) {
      data['medicines'] = this.medicines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medicines {
  int id;
  int userId;
  int medicineId;
  String createdAt;
  String updatedAt;
  List<String> times;
  Medicine medicine;

  Medicines(
      {this.id,
      this.userId,
      this.medicineId,
      this.createdAt,
      this.updatedAt,
      this.times,
      this.medicine});

  Medicines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    medicineId = json['medicine_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    times = json['times'].cast<String>();
    medicine = json['medicine'] != null
        ? new Medicine.fromJson(json['medicine'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['medicine_id'] = this.medicineId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['times'] = this.times;
    if (this.medicine != null) {
      data['medicine'] = this.medicine.toJson();
    }
    return data;
  }
}

class Medicine {
  int id;
  String name;
  int isSelected;
  String createdAt;
  String updatedAt;

  Medicine(
      {this.id, this.name, this.isSelected, this.createdAt, this.updatedAt});

  Medicine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isSelected = json['isSelected'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isSelected'] = this.isSelected;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
