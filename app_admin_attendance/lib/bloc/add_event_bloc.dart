import 'dart:io';
import 'package:app_admin_attendance/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class AddEventBloC {
  final _imagePicker = BehaviorSubject<XFile>();
  Stream<XFile> get imagePickerStream => _imagePicker.stream;

  final _addressController = BehaviorSubject<TextEditingController>();
  Stream<TextEditingController> get addressStream => _addressController.stream;

  final _isEdit = BehaviorSubject<bool>()..add(false);
  Stream<bool> get isEditStream => _isEdit.stream;

  set changeStateImageEdit(bool value) => _isEdit.add(true);

  CollectionReference data = FirebaseFirestore.instance.collection('Events');

  String name = '';
  String description = '';
  String address = '';
  String pathImage = '';
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? timeStart;
  TimeOfDay? timeEnd;
  double latLocationEvent = 0.0;
  double lngLocationEvent = 0.0;
  int lengthEvents = 0;

  set setName(String value) => name = value;
  set setAddress(String value) => address = value;
  set addAddressStream(TextEditingController value) =>
      _addressController.add(value);
  set setDescription(String value) => description = value;
  set setStartDate(DateTime value) => startDate = value;
  set setEndDate(DateTime value) => endDate = value;
  set setTimeStart(TimeOfDay value) => timeStart = value;
  set setTimeEnd(TimeOfDay value) => timeEnd = value;
  set setLatLocationEvent(double value) => latLocationEvent = value;
  set setLngLocationEvent(double value) => lngLocationEvent = value;

  Future getImageDevice() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    _imagePicker.add(image!);
  }

//Upload photos to firebase
  uploadFile() async {
    File imageFile = File(_imagePicker.value.path);
    await FirebaseStorage.instance
        .ref()
        .child('Events/$name')
        .putFile(imageFile);
  }

// get url from firebase
  getUrlImage() async {
    await FirebaseStorage.instance
        .ref()
        .child('Events/$name')
        .getDownloadURL()
        .then((value) => pathImage = value);
  }

  lengthEvent() async {
    var events = await FirebaseFirestore.instance.collection('Events').get();
    lengthEvents = events.size;
  }

  bool isFillInAllData() {
    if (name.isNotEmpty &&
        description.isNotEmpty &&
        address.isNotEmpty &&
        latLocationEvent != 0.0 &&
        lngLocationEvent != 0.0 &&
        startDate != null &&
        endDate != null &&
        timeStart != null &&
        timeEnd != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> createEvent() async {
    await uploadFile();
    await getUrlImage();
    await lengthEvent();
    var request = Event(
      id: lengthEvents + 1,
      name: name,
      pathImage: pathImage,
      description: description,
      address: address,
      startDate: DateTime(startDate!.year, startDate!.month, startDate!.day,
              timeStart!.hour, timeStart!.minute)
          .millisecondsSinceEpoch,
      endDate: DateTime(endDate!.year, endDate!.month, endDate!.day,
              timeEnd!.hour, timeEnd!.minute)
          .millisecondsSinceEpoch,
      latLocationEvent: latLocationEvent,
      lngLocationEvent: lngLocationEvent,
    ).toJson();
    data
        .doc('${lengthEvents + 1}')
        .set(request)
        .then((value) => print('Added'))
        .catchError((onError) {
      print(onError);
    });
  }

  initEditDataEvent(Event event) {
    name = event.name ?? '';
    description = event.description ?? '';
    address = event.address ?? '';
    pathImage = event.pathImage ?? '';
    _imagePicker.add(XFile(pathImage));
    startDate = DateTime.fromMillisecondsSinceEpoch(event.startDate ?? 0);
    endDate = DateTime.fromMillisecondsSinceEpoch(event.endDate ?? 0);
    latLocationEvent = event.latLocationEvent ?? 0;
    lngLocationEvent = event.lngLocationEvent ?? 0;
    timeStart = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(event.startDate ?? 0));
    timeEnd = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(event.endDate ?? 0));
  }

  Future<void> editEvent(int eventID) async {
    if (pathImage != _imagePicker.value.path) {
      await uploadFile();
      await getUrlImage();
    }
    var editData = Event(
      id: eventID,
      name: name,
      pathImage: pathImage,
      description: description,
      address: address,
      startDate: DateTime(startDate!.year, startDate!.month, startDate!.day,
              timeStart!.hour, timeStart!.minute)
          .millisecondsSinceEpoch,
      endDate: DateTime(endDate!.year, endDate!.month, endDate!.day,
              timeEnd!.hour, timeEnd!.minute)
          .millisecondsSinceEpoch,
      latLocationEvent: latLocationEvent,
      lngLocationEvent: lngLocationEvent,
    ).toJson();
    data
        .doc('$eventID')
        .update(editData)
        .then((value) => print("edit success"))
        .catchError((error) => print("Failed to edit event: $error"));
  }

  void dispose() {
    _imagePicker.close();
    _addressController.close();
  }
}
