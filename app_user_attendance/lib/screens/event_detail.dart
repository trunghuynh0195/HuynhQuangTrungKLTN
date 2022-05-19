import 'package:app_user_attendance/models/event.dart';
import 'package:app_user_attendance/util/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetail extends StatelessWidget {
  final Event event;
  const EventDetail({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFBFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFAFBFF),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          color: AppColor.primaryDarkBlue,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _information(),
    );
  }

  Widget _information() {
    String startDate = DateFormat("dd MMM yyyy").format(
        DateTime.fromMillisecondsSinceEpoch(event.startDate?.toInt() ?? 0));
    String endDate = DateFormat("dd MMM yyyy").format(
        DateTime.fromMillisecondsSinceEpoch(event.endDate?.toInt() ?? 0));
    String timeStart = DateFormat('HH:mm aa').format(
        DateTime.fromMillisecondsSinceEpoch(event.startDate?.toInt() ?? 0));
    String timeEnd = DateFormat('HH:mm aa').format(
        DateTime.fromMillisecondsSinceEpoch(event.endDate?.toInt() ?? 0));
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(event),
            const SizedBox(
              height: 20,
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
                    // color: Color.fromARGB(255, 200, 84, 76),
                    color: Color.fromARGB(255, 72, 109, 184),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                "Thời gian: $timeStart - $timeEnd",
                style: const TextStyle(
                    color: Color.fromARGB(255, 72, 109, 184),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 12),
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
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
}
