class ToDo {
  final String name;
  final String date;
  final String time;

  ToDo({required this.name, required this.date, required this.time});

  toJson() {
    return {
      'name': name,
      'date': date,
      'time': time,
    };
  }

  static fromJson(jsonData) {
    return ToDo(
        name: jsonData['name'], date: jsonData['date'], time: jsonData['time']);
  }
}
