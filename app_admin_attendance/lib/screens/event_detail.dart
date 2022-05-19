import 'package:app_admin_attendance/bloc/event_detail_bloc.dart';
import 'package:app_admin_attendance/models/event.dart';
import 'package:app_admin_attendance/screens/add_event.dart';
import 'package:app_admin_attendance/screens/home.dart';
import 'package:app_admin_attendance/screens/list_user_attendance_event.dart';
import 'package:app_admin_attendance/utils/app_color.dart';
import 'package:app_admin_attendance/utils/commom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventDetail extends StatelessWidget {
  final Event event;
  const EventDetail({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey renderObjectKey = GlobalKey();
    return Scaffold(
      backgroundColor: const Color(0xffFAFBFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFAFBFF),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.blue,
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () => _showModalBottomSheet(context, renderObjectKey),
              icon: const Icon(
                Icons.qr_code,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _information(context),
          _button(context),
        ],
      ),
    );
  }

  Widget _button(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MaterialButton(
              onPressed: () => confirmDeleteEvent(context),
              color: Colors.red,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Delete',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: MaterialButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => AddEvent(
                      isEdit: true,
                      event: event,
                    ),
                  ),
                );
              },
              color: Colors.blue,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Edit',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _information(BuildContext context) {
    String startDate = DateFormat("dd MMM yyyy").format(
        DateTime.fromMillisecondsSinceEpoch(event.startDate?.toInt() ?? 0));
    String endDate = DateFormat("dd MMM yyyy").format(
        DateTime.fromMillisecondsSinceEpoch(event.endDate?.toInt() ?? 0));

    String timeStart = DateFormat('HH:mm').format(
        DateTime.fromMillisecondsSinceEpoch(event.startDate?.toInt() ?? 0));
    String timeEnd = DateFormat('HH:mm').format(
        DateTime.fromMillisecondsSinceEpoch(event.endDate?.toInt() ?? 0));

    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(event),
              const SizedBox(
                height: 25,
              ),
              Text(
                event.name ?? '',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryDarkBlue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 15),
                child: Text(
                  '${event.description}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
                color: Color(0xFFE4E9F2),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  "Từ ngày: $startDate - $endDate",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 200, 84, 76),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  "Thời gian: $timeStart - $timeEnd",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 200, 84, 76),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 12, bottom: 30),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        event.address ?? '',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ListUserAttendanceEvent(listUser: event.listUser ?? []),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.assignment,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: 1, // space between underline and text
                      ),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: AppColor.primaryDarkBlue,
                        width: 1.0, // Underline width
                      ))),
                      child: const Text(
                        'Danh sách điểm danh',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.primaryDarkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(Event event) {
    return CachedNetworkImage(
      imageUrl: '${event.pathImage}',
      progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          height: 200,
          alignment: Alignment.center,
          child: CircularProgressIndicator(value: downloadProgress.progress)),
      errorWidget: (context, url, error) => Container(
          height: 200,
          alignment: Alignment.center,
          child: const Icon(Icons.error)),
      imageBuilder: (context, imageProvider) => Container(
        height: 200,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, renderObjectKey) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Text(
                "Scan QR code",
                style: TextStyle(
                    color: AppColor.primaryDarkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: 62, right: 62, top: 20),
              child: RepaintBoundary(
                key: renderObjectKey,
                child: QrImage(
                  data: event.id.toString(),
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: GestureDetector(
                onTap: () =>
                    EventDetailBloC().captureAndSharePng(renderObjectKey),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.share,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Share",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              color: Colors.blue,
              height: 60,
              minWidth: MediaQuery.of(context).size.width,
              child: const Text(
                "Done",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  void confirmDeleteEvent(BuildContext context) {
    showConfirmDialog(context,
            message: 'Bạn có chắc chắn muốn xóa sự kiện này?')
        .then((accept) {
      if (accept) {
        EventDetailBloC().deleteEvent('${event.id}').then((value) {
          showSnackBar(context, 'Xóa thành công!');
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
