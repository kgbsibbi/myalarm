class Alarm {
  int? id;
  DateTime? time;

  Map<String, Object?> toMap(){
    var map = <String, Object?>{
      "id":id,
      "year": time?.year,
      "month": time?.month,
      "day": time?.day,
      "hour": time?.hour,
      "minute": time?.minute
    };
    return map;
  }

  Alarm.fromMap(Map<String, Object?> map){
    id = map['id'] as int;
    time = DateTime(
      map['year'] as int,
      map['month'] as int,
      map['day'] as int,
      map['hour'] as int,
      map['minute'] as int
    );
  }

  Alarm.fromData(this.id, this.time);
}