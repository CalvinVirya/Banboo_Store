class AdminUsername {
  String username;

  AdminUsername({
    required this.username,
  });

  factory AdminUsername.fromJson(Map<String, dynamic> json) => AdminUsername(
        username: json["username"].toString(),
      );
}
