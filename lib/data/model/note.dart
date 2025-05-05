
class Note {
  String? id;
  String? data;

  Note({
     this.id,
      this.data
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      data: json['data'],
    );
  }
}

