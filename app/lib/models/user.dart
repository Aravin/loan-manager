class AppUser {
  final String name;
  final String email;
  final String uid;

  AppUser(this.name, this.email, this.uid);

  AppUser.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        uid = json['uid'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'uid': uid,
      };
}
