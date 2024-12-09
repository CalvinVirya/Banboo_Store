class User {
  int id;
  String fullname;
  String username;
  String email;
  String token;

  User(
      {required this.id,
      required this.fullname,
      required this.username,
      required this.email,
      required this.token});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] as int,
        fullname: json["fullname"].toString(),
        username: json["username"].toString(),
        email: json["email"].toString(),
        token: json["token"].toString(),
      );
  void reset() {
    id = 0;
    fullname = '';
    username = '';
    email = '';
    token = '';
  }
}
