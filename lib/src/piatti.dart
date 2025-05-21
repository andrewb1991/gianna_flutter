class Piatto {
  late final String id;
 late final String name;
  late final String description;
  late final String thumbnail;
  late final String price;
  
  Piatto(
      {required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.price});

 Piatto.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = (json['price'] == null) ? '' : json['price'].toString();
    description =
        (json['description'] == null) ? '' : json['description'].toString();
      thumbnail = (json['thumbnail'] == null) 
        ? '' 
        : json['thumbnail'].toString();
    }
}
    



