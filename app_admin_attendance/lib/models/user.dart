class User {
  String? uid;
  String? email;
  String? address;
  String? dateOfBirth;
  String? firstName;
  String? mcb;
  String? lastName;
  String? fullName;
  String? phoneNumber;
  String? roles;
  String? majoring;
  String? msv;
  String? course;

  User({this.uid, this.email});

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    address = json['address'];
    lastName = json['last_name'];
    firstName = json['first_name'];
    mcb = json['mcb'];
    msv = json['msv'];
    fullName = json['full_name'];
    roles = json['roles'];
    phoneNumber = json['phone_number'];
    dateOfBirth = json['date_of_birth'];
    course = json['course'];
    majoring = json['majoring'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    return data;
  }
}
