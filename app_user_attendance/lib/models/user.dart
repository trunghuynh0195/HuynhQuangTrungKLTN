class User {
  String? uid;
  String? email;
  String? address;
  String? course;
  String? dateOfBirth;
  String? firstName;
  String? lastName;
  String? fullName;
  String? majoring;
  String? msv;
  String? phoneNumber;
  String? roles;
  String? unit;

  User({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.fullName,
    this.address,
    this.course,
    this.dateOfBirth,
    this.majoring,
    this.msv,
    this.phoneNumber,
    this.roles,
    this.unit,
  });

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    address = json['address'];
    course = json['course'];
    majoring = json['majoring'];
    lastName = json['last_name'];
    firstName = json['first_name'];
    fullName = json['full_name'];
    msv = json['msv'];
    roles = json['roles'];
    phoneNumber = json['phone_number'];
    dateOfBirth = json['date_of_birth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['address'] = address;
    data['last_name'] = lastName;
    data['first_name'] = firstName;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['unit'] = unit;
    return data;
  }
}
