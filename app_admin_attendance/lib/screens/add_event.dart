import 'dart:io';
import 'package:app_admin_attendance/bloc/add_event_bloc.dart';
import 'package:app_admin_attendance/models/event.dart';
import 'package:app_admin_attendance/screens/google_map_picker.dart';
import 'package:app_admin_attendance/screens/home.dart';
import 'package:app_admin_attendance/utils/commom_widget.dart';
import 'package:app_admin_attendance/utils/widgets/text_field_widget.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddEvent extends StatefulWidget {
  final bool isEdit;
  final Event? event;

  const AddEvent({
    Key? key,
    this.isEdit = false,
    this.event,
  }) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final AddEventBloC _bloC = AddEventBloC();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _timeStartDateController =
      TextEditingController();
  final TextEditingController _timeEndDateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  String pathImage = '';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.event?.name ?? '';
    _descriptionController.text = widget.event?.description ?? '';
    if (widget.event?.startDate != null) {
      _timeStartDateController.text = DateFormat('HH:MM').format(
          DateTime.fromMillisecondsSinceEpoch(widget.event?.startDate ?? 0));
      _timeEndDateController.text = DateFormat('HH:MM').format(
          DateTime.fromMillisecondsSinceEpoch(widget.event?.endDate ?? 0));
      _startDateController.text = DateFormat('dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(widget.event?.startDate ?? 0));
      _endDateController.text = DateFormat('dd/MM/yyyy').format(
          DateTime.fromMillisecondsSinceEpoch(widget.event?.endDate ?? 0));
    }
    if (widget.isEdit) {
      _bloC.initEditDataEvent(widget.event ?? Event());
    }
    _addressController.text = widget.event?.address ?? '';
    pathImage = widget.event?.pathImage ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFBFF),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xffFAFBFF),
        title: Text(
          widget.isEdit ? 'Edit Event' : 'Add Event',
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
      ),
      body: KeyboardDismisser(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _input(),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _input() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _name(),
            _pickDate(),
            _pickTime(),
            _mapPicker(),
            _description(),
            _addImage(),
          ],
        ),
      ),
    );
  }

  Widget _name() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFieldWidget(
        controller: _nameController,
        contentPadding: const EdgeInsets.all(20),
        hintText: 'Tên sự kiện...',
        onChanged: (value) {
          _bloC.setName = value;
        },
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextFieldWidget(
        controller: _descriptionController,
        contentPadding: const EdgeInsets.all(20),
        maxLines: 5,
        hintText: 'Mô tả...',
        onChanged: (value) {
          _bloC.setDescription = value;
        },
      ),
    );
  }

  Widget _pickDate() {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            height: 50,
            controller: _startDateController,
            keyboardType: TextInputType.datetime,
            hintText: 'Start Date',
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            readOnly: true,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Icon(
                Icons.calendar_today_outlined,
                color: Colors.grey,
                size: 20,
              ),
            ),
            onTap: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: DateTime.now(),
                maxTime: DateTime(2100, 1, 1),
                locale: LocaleType.vi,
                onConfirm: (date) {
                  _startDateController.text =
                      DateFormat('dd/MM/yyyy').format(date);
                  _bloC.setStartDate = date;
                },
              );
            },
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: TextFieldWidget(
            height: 50,
            controller: _endDateController,
            keyboardType: TextInputType.datetime,
            hintText: 'End Date',
            readOnly: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            onTap: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: DateTime.now(),
                maxTime: DateTime(2100, 1, 1),
                locale: LocaleType.vi,
                onConfirm: (date) {
                  _endDateController.text =
                      DateFormat('dd/MM/yyyy').format(date);
                  _bloC.setEndDate = date;
                },
              );
            },
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Icon(
                Icons.calendar_today_outlined,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pickTime() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: TextFieldWidget(
              height: 50,
              controller: _timeStartDateController,
              keyboardType: TextInputType.datetime,
              hintText: 'Time Start',
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              readOnly: true,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.timer,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  if (value != null) {
                    _timeStartDateController.text = value.format(context);
                    _bloC.setTimeStart =
                        TimeOfDay(hour: value.hour, minute: value.minute);
                  }
                });
              },
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextFieldWidget(
              height: 50,
              controller: _timeEndDateController,
              keyboardType: TextInputType.datetime,
              hintText: 'Time End',
              readOnly: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  if (value != null) {
                    _timeEndDateController.text = value.format(context);
                    _bloC.setTimeEnd =
                        TimeOfDay(hour: value.hour, minute: value.minute);
                  }
                });
              },
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.timer,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addImage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: GestureDetector(
        onTap: () {
          _bloC.getImageDevice();
          _bloC.changeStateImageEdit = true;
        },
        child: StreamBuilder<bool>(
            stream: _bloC.isEditStream,
            builder: (context, snapshot) {
              bool isEditImage = snapshot.data ?? false;
              return StreamBuilder<XFile>(
                  stream: _bloC.imagePickerStream,
                  builder: (context, snapshot) {
                    XFile? _imageFile = snapshot.data;
                    if (snapshot.hasData) {
                      return isEditImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                height: 250,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(
                                        File('${_imageFile?.path}'),
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                height: 250,
                                width: double.infinity,
                                child: Image.network(
                                  _imageFile?.path ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                    }
                    return Container(
                      decoration: DottedDecoration(
                        dash: const [9, 6],
                        strokeWidth: 1.0,
                        color: const Color(0xFF9A9A9A),
                        shape: Shape.box,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.image,
                              size: 25,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Add image",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }

  Widget _mapPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: StreamBuilder<TextEditingController>(
          stream: _bloC.addressStream,
          builder: (context, snapshot) {
            _addressController = snapshot.data ?? _addressController;
            return TextFieldWidget(
              controller: _addressController,
              contentPadding: const EdgeInsets.all(20),
              hintText: 'Chọn địa điểm...',
              suffixIcon: const Icon(
                Icons.location_on_outlined,
                color: Colors.grey,
              ),
              readOnly: true,
              onTap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => GoogleMapPicker(_bloC),
                  ),
                );
              },
            );
          }),
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      child: Row(
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            minWidth: 111,
            color: const Color(0xffFAFBFF),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey)),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: MaterialButton(
              onPressed: widget.isEdit ? confirmEditEvent : confirmAddEvent,
              color: Colors.blue,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent)),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showDialogLoading() {
    showDialog(
        context: context,
        builder: (_) {
          return Container(
            color: Colors.white.withOpacity(0.2),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        });
  }

  void confirmAddEvent() {
    showConfirmDialog(context, message: 'Tạo sự kiện?').then((accept) {
      if (accept) {
        if (_bloC.isFillInAllData()) {
          showDialogLoading();
          _bloC.createEvent().then((value) {
            showSnackBar(context, 'Tạo sự kiện thành công!');
            // Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Home()),
                (route) => false);
          }).catchError((dynamic error) {
            showSnackBar(
              context,
              error.toString(),
            );
          });
        } else {
          showSnackBar(context, 'Thông tin bạn nhập chưa đầy đủ!');
        }
      }
    });
  }

  void confirmEditEvent() {
    showConfirmDialog(context, message: 'Bạn có chắc chắn muốn cập nhật?')
        .then((accept) {
      if (accept) {
        _bloC.editEvent(widget.event?.id ?? 0).then((value) {
          showSnackBar(context, 'Cập nhật thành công!');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Home()),
              (route) => false);
        }).catchError((dynamic error) {
          showSnackBar(
            context,
            error.toString(),
          );
        });
      }
    });
  }
}
