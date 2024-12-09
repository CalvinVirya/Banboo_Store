class Banboo {
  int banboo_id;
  String banboo_name;
  int price;
  String rank;
  int level;
  int hp;
  int atk;
  int def;
  int impact;
  String crit_rate;
  String crit_dmg;
  String pen_ratio;
  int anomaly_mastery;
  int element_id;
  String banboo_desc;
  String banboo_image;
  String element_name;

  Banboo(
      {required this.banboo_id,
      required this.banboo_name,
      required this.price,
      required this.rank,
      required this.level,
      required this.hp,
      required this.atk,
      required this.def,
      required this.impact,
      required this.crit_rate,
      required this.crit_dmg,
      required this.pen_ratio,
      required this.anomaly_mastery,
      required this.element_id,
      required this.banboo_desc,
      required this.banboo_image,
      required this.element_name});
  factory Banboo.fromJson(Map<String, dynamic> json) => Banboo(
        banboo_id: json["banboo_id"] as int,
        banboo_name: json["banboo_name"].toString(),
        price: json["price"] as int,
        rank: json["rank"].toString(),
        level: json["level"] as int,
        hp: json["hp"] as int,
        atk: json["atk"] as int,
        def: json["def"] as int,
        impact: json["impact"] as int,
        crit_rate: json["crit_rate"].toString(),
        crit_dmg: json["crit_dmg"].toString(),
        pen_ratio: json["pen_ratio"].toString(),
        anomaly_mastery: json["anomaly_mastery"] as int,
        element_id: json["element_id"] as int,
        banboo_desc: json["banboo_desc"].toString(),
        banboo_image: json["banboo_image"].toString(),
        element_name: json["element_name"].toString(),
      );
}
