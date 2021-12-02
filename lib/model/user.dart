class User {
  String email;
  String password;
  String token;
  String sId;

  User({this.email, this.password, this.token, this.sId});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    token = json['token'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['token'] = this.token;
    data['_id'] = this.sId;
    return data;
  }
}