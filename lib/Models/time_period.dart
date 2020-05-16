class DayPeriod {
  DateTime start;
  DateTime end;

  DayPeriod.fromEmpty() {
    this.start = DateTime(0, 0, 0, DateTime.now().hour, DateTime.now().minute);
    this.end = DateTime(0, 0, 0, DateTime.now().hour, DateTime.now().minute);
  }

  DayPeriod.fromJson(json) {
    var st = json["start"].split(":");
    var et = json['end'].split(":");
    this.start = DateTime(0, 0, 0, int.parse(st[0]), int.parse(st[1]));
    this.end = DateTime(0, 0, 0, int.parse(et[0]), int.parse(et[1]));
  }

  Map<String, dynamic> toJson() {
    return {
      'start':
          '${this.start.hour}:${this.start.minute.toString().padLeft(2, '0')}',
      'end': '${this.end.hour}:${this.end.minute.toString().padLeft(2, '0')}'
    };
  }
}
