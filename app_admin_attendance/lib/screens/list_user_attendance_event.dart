import 'package:app_admin_attendance/bloc/list_user_attendance_event_bloc.dart';
import 'package:app_admin_attendance/models/user.dart';
import 'package:app_admin_attendance/utils/app_color.dart';
import 'package:flutter/material.dart';

class ListUserAttendanceEvent extends StatefulWidget {
  final List<User> listUser;
  const ListUserAttendanceEvent({Key? key, this.listUser = const []})
      : super(key: key);

  @override
  State<ListUserAttendanceEvent> createState() =>
      _ListUserAttendanceEventState();
}

class _ListUserAttendanceEventState extends State<ListUserAttendanceEvent> {
  final ListUserAttendanceEventBloC _bloC = ListUserAttendanceEventBloC();
  List<User> users = [];
  @override
  void initState() {
    super.initState();
    users = widget.listUser;
    _bloC.getListUser(users);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffFAFBFF),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            color: AppColor.primaryDarkBlue,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 25),
              child: Text(
                'Danh sách sinh viên đã điểm danh',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    color: AppColor.primaryDarkBlue,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<User>>(
                  initialData: const [],
                  stream: _bloC.listUserStream,
                  builder: (_, snapshot) {
                    List<User> users = snapshot.data ?? [];
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (users.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Danh sách trống',
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (_, index) {
                        int stt = index + 1;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 10),
                                    child: Text(
                                      '$stt',
                                      style: const TextStyle(
                                          // color: Color(0xFF667085),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildText('Họ và tên: ',
                                            '${users[index].fullName}'),
                                        _buildText('Mã sinh viên: ',
                                            '${users[index].msv}'),
                                        _buildText(
                                            'Khóa: ', '${users[index].course}'),
                                        _buildText('Chuyên ngành: ',
                                            '${users[index].majoring}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String title, String information) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: title,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: information,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }
}
