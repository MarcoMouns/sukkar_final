class GetMeasureFriends {
  MeasurementsBean Measurements;

  GetMeasureFriends({this.Measurements});

  GetMeasureFriends.fromJson(Map<String, dynamic> json) {    
    this.Measurements = json['Measurements'] != null ? MeasurementsBean.fromJson(json['Measurements']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.Measurements != null) {
      data['Measurements'] = this.Measurements.toJson();
    }
    return data;
  }

}

class MeasurementsBean {
  String SystolicPressure;
  String DiastolicPressure;
  String sleepStartTime;
  String SleepEndTime;
  String waterCups;
  String sugar;
  String date;
  String Heartbeat;
  String createdAt;
  String updatedAt;
  String day;
  int id;
  int dayCalories;
  int NumberOfSteps;
  int userId;
  int distance;

  MeasurementsBean({this.SystolicPressure, this.DiastolicPressure, this.sleepStartTime, this.SleepEndTime, this.waterCups, this.sugar, this.date, this.Heartbeat, this.createdAt, this.updatedAt, this.day, this.id, this.dayCalories, this.NumberOfSteps, this.userId, this.distance});

  MeasurementsBean.fromJson(Map<String, dynamic> json) {    
    this.SystolicPressure = json['SystolicPressure'];
    this.DiastolicPressure = json['DiastolicPressure'];
    this.sleepStartTime = json['sleepStartTime'];
    this.SleepEndTime = json['SleepEndTime'];
    this.waterCups = json['water_cups'];
    this.sugar = json['sugar'];
    this.date = json['date'];
    this.Heartbeat = json['Heartbeat'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
    this.day = json['day'];
    this.id = json['id'];
    this.dayCalories = json['day_Calories'];
    this.NumberOfSteps = json['NumberOfSteps'];
    this.userId = json['user_id'];
    this.distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SystolicPressure'] = this.SystolicPressure;
    data['DiastolicPressure'] = this.DiastolicPressure;
    data['sleepStartTime'] = this.sleepStartTime;
    data['SleepEndTime'] = this.SleepEndTime;
    data['water_cups'] = this.waterCups;
    data['sugar'] = this.sugar;
    data['date'] = this.date;
    data['Heartbeat'] = this.Heartbeat;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['day'] = this.day;
    data['id'] = this.id;
    data['day_Calories'] = this.dayCalories;
    data['NumberOfSteps'] = this.NumberOfSteps;
    data['user_id'] = this.userId;
    data['distance'] = this.distance;
    return data;
  }
}
