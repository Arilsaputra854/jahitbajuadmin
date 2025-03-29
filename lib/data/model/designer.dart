
import 'package:jahit_baju_admin/data/model/look.dart';

class Designer {
  String? id;
  String name;
  String description;
  List<Look>? looks;
  DateTime? lastUpdate;

  Designer({
     this.id,
    required this.name,
    this.looks,
    required this.description,
     this.lastUpdate,
  });

  factory Designer.fromJson(Map<String, dynamic> json) {
    return Designer(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      looks: json['looks'] != null
          ? (json['looks'] as List).map((item) => Look.fromJson(item)).toList()
          : null,
      lastUpdate: json['last_update']  != null? DateTime.parse(json['last_update']) : null,
    );
  }
}

