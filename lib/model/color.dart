class ColorsModel {
  ColorsModel({
    this.name,
    this.code,
  });

  String name;
  String code;

  factory ColorsModel.fromJson(Map<String, dynamic> json) => ColorsModel(
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
  };
}
