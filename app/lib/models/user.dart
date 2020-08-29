class User {
  final String name;
  final String email;
  final String uid;

  User(this.name, this.email, this.uid);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        uid = json['uid'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'uid': uid,
      };
}
