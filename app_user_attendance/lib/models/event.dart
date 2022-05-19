import 'package:app_user_attendance/models/user.dart';

class Event {
  int? id;
  String? name;
  String? description;
  String? pathImage;
  String? address;
  int? startDate;
  int? endDate;
  double? latLocationEvent;
  double? lngLocationEvent;
  List<User>? listUser;
  Event({
    this.id,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.pathImage,
    this.address,
    this.latLocationEvent,
    this.lngLocationEvent,
    this.listUser,
  });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pathImage = json['path_image'];
    address = json['address'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    latLocationEvent = json['lat_location_event'];
    lngLocationEvent = json['lng_location_event'];
    listUser = json['list_user'] == null
        ? []
        : (json['list_user'] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map((user) => User.fromJson(user))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['path_image'] = pathImage;
    data['address'] = address;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['lat_location_event'] = latLocationEvent;
    data['lng_location_event'] = lngLocationEvent;
    data['list_user'] = listUser?.cast<Map<String, dynamic>>().map(
          (user) => Event.fromJson(user),
        );
    return data;
  }
}
