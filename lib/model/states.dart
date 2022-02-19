class States {
  States({
    this.id,
    this.countryId,
    this.name,
    this.arName,
    this.kuName,
    this.enName,
    this.cost,
  });
  int id;
  int countryId;
  String name;
  dynamic arName;
  dynamic kuName;
  dynamic enName;
  int cost;

  factory States.fromJson(Map<String, dynamic> json) => States(
    id: json["id"],
    countryId: json["country_id"],
    name: json["name"],
    arName: json["ar_name"],
    kuName: json["ku_name"],
    enName: json["en_name"],
    cost: json["cost"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "name": name,
    "ar_name": arName,
    "ku_name": kuName,
    "en_name": enName,
    "cost": cost,
  };
}
