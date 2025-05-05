
import 'package:jahit_baju_admin/data/model/look_texture.dart';

class Look {
  String? id;
  String designerId;
  String name;
  String designUrl;
  List<String>? features;
  String description;
  List<String>? size;
  List<String>? materials;
  final double price;
  final double lookPrice;
  String lastUpdate;
  int sold;
  int seen;
  int weight;

  Look({
     this.id,
    required this.designerId,
    required this.name,
    required this.designUrl,
    this.features,
    required this.description,
    required this.materials,
    this.size,
    required this.price,
    required this.lookPrice,
    required this.lastUpdate,
    required this.sold,
    required this.seen,
    required this.weight
  });

  factory Look.fromJson(Map<String, dynamic> json) {
    return Look(
      id: json['id'],
      designerId: json['designer_id'],
      name: json['name'],
      features: json['features'] != null
          ? List<String>.from(json['features'])
          : null,
      materials: json['materials'] != null
          ? List<String>.from(json['materials'])
          : null,
      price: (json['price'] as num).toDouble(),
      lookPrice: (json['look_price'] as num).toDouble(),
      designUrl: json['design_url'],
      description: json['description'],
      size: json['size'] != null
          ? List<String>.from(json['size'])
          : null,
      lastUpdate: json['last_update'],
      sold: json['sold'],
      seen: json['seen'],
      weight: json['weight'],
    );
  }
  Map<String, dynamic> toJson() {
  return {
    'designer_id': designerId,
    'name': name,
    'features': features,
    'materials': materials,
    'price': price,
    'look_price': lookPrice,
    'design_url': designUrl,
    'description': description,
    'size': size,
    'sold': sold,
    'seen': seen,
    'weight': weight,
  };
}
}