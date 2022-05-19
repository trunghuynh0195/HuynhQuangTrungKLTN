import 'package:app_user_attendance/bloc/attendance_event_bloc.dart';
import 'package:app_user_attendance/models/event.dart';
import 'package:app_user_attendance/screens/event_detail.dart';
import 'package:app_user_attendance/util/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';
import 'package:app_user_attendance/extensions/format_date_to_vn.dart';

class AttendanceEvent extends StatefulWidget {
  const AttendanceEvent({Key? key}) : super(key: key);

  @override
  State<AttendanceEvent> createState() => _AttendanceEventState();
}

class _AttendanceEventState extends State<AttendanceEvent> {
  final AttendanceEventBloC _bloC = AttendanceEventBloC();
  int _currentIndex = 0;
  DateTime _currentDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _bloC.getListEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 237, 238, 243),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 32),
              child: Text(
                'Quản lý điểm danh',
                style: TextStyle(
                    fontSize: 20,
                    color: AppColor.primaryDarkBlue,
                    fontWeight: FontWeight.bold),
              ),
            ),
            _buildEvents(),
          ],
        ),
      ),
    );
  }

  Widget _buildEvents() {
    return Expanded(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildEventHappening(),
            _buildEventComing(),
          ],
        ),
      ),
    ));
  }

  Widget _buildEventComing() {
    String date = DateFormat("MM/yyyy").format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 22, top: 45),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sắp diễn ra',
                style: TextStyle(
                  color: AppColor.primaryDarkBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: AppColor.primaryDarkBlue,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              7,
              (index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      _currentDay = DateTime.now().add(Duration(days: index));
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 72,
                    width: 72,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColor.primaryDarkBlue
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat("dd").format(
                              DateTime.now().add(Duration(days: index))),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: _currentIndex == index
                                ? Colors.white
                                : AppColor.primaryDarkBlue,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateTime.now()
                              .add(Duration(days: index))
                              .formatDayOfWeekVN,
                          style: TextStyle(
                            color: _currentIndex == index
                                ? Colors.white
                                : AppColor.primaryDarkBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 36,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: StreamBuilder<List<Event>>(
            stream: _bloC.listEventStream,
            builder: (context, snapshot) {
              List<Event> listEvent = snapshot.data ?? [];
              List<Event> listEventInDay =
                  listEvent.where((event) => checkEventComing(event)).toList();
              if (listEventInDay.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/event_coming.png',
                        height: 115,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Không có sự kiện nào',
                        style: TextStyle(
                          color: Color(0xFF98A2B3),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: List.generate(
                  listEventInDay.length,
                  (index) {
                    String timeStart = DateFormat("HH:mm").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            listEventInDay[index].startDate?.toInt() ?? 0));
                    String timeEnd = DateFormat("HH:mm").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            listEventInDay[index].endDate?.toInt() ?? 0));
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => EventDetail(
                                  event: listEventInDay[index],
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${listEventInDay[index].name}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: AppColor.primaryDarkBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text(
                                        "$timeStart - $timeEnd",
                                        style: const TextStyle(
                                          color: AppColor.primaryDarkBlue,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      listEventInDay[index].address ?? '',
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: AppColor.primaryDarkBlue,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: AppColor.primaryDarkBlue,
                              ),
                            ],
                          ),
                        ),
                        if (index + 1 != listEventInDay.length)
                          const Divider(
                            thickness: 1,
                          ),
                        const SizedBox(
                          height: 13,
                        )
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }

  Widget _buildEventHappening() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Đang diễn ra',
            style: TextStyle(
              color: AppColor.primaryDarkBlue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        StreamBuilder<List<Event>>(
          stream: _bloC.listEventStream,
          builder: (context, snapshot) {
            List<Event> listEvent = snapshot.data ?? [];
            List<Event> listEventInDayHappening =
                listEvent.where((event) => checkEventHappening(event)).toList();
            if (listEventInDayHappening.isEmpty) {
              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/event_happening.png',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Không có sự kiện nào đang diễn ra',
                      style: TextStyle(
                        color: Color(0xFF98A2B3),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: List.generate(
                listEventInDayHappening.length,
                (index) {
                  return GestureDetector(
                    onTap: () => Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => EventDetail(
                          event: listEventInDayHappening[index],
                        ),
                      ),
                    ),
                    child: Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildImage(listEventInDayHappening[index]),
                          _buildInformation(listEventInDayHappening[index]),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInformation(Event event) {
    List list = (event.listUser ?? []).map((e) => e.uid).toList();
    bool isAttendance =
        list.contains(auth.FirebaseAuth.instance.currentUser?.uid);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _buildTitle(event),
          ),
          _buildTime(event),
          _buildAddress(event),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: (event.listUser ?? []).isNotEmpty
                        ? Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 2, right: 5),
                                child: Icon(
                                  Icons.people,
                                  color: Color(0xFF667085),
                                ),
                              ),
                              Text(
                                '+ ${event.listUser?.length}',
                                style: const TextStyle(
                                  color: Color(0xFF667085),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                if (isAttendance) Expanded(child: _isAttendance()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTime(Event event) {
    String startDate = DateFormat("dd MMM yyyy").format(
        DateTime.fromMillisecondsSinceEpoch(event.startDate?.toInt() ?? 0));
    String endDate = DateFormat("dd MMM yyyy").format(
        DateTime.fromMillisecondsSinceEpoch(event.endDate?.toInt() ?? 0));
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          const Icon(
            Icons.access_time_filled_rounded,
            size: 20,
            color: Color(0xFF667085),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            "$startDate - $endDate",
            style: const TextStyle(color: Color(0xFF667085), fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(Event event) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 2),
            child: Icon(
              Icons.location_on_rounded,
              color: Color(0xFF667085),
              size: 22,
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          Expanded(
            child: Text(
              event.address ?? '',
              maxLines: 1,
              style: const TextStyle(
                color: Color(0xFF667085),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _isAttendance() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: const Color(0xFFECFDF3),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFD1FADF))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.done,
            color: Colors.green,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Đã điểm danh',
            style: TextStyle(
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImage(Event event) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(11), topRight: Radius.circular(11)),
      child: CachedNetworkImage(
        imageUrl: '${event.pathImage}',
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          height: 200,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
          ),
        ),
        errorWidget: (context, url, error) => Container(
            height: 200,
            alignment: Alignment.center,
            child: const Icon(Icons.error)),
        imageBuilder: (context, imageProvider) => Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(Event event) {
    return Text(
      '${event.name}',
      style: const TextStyle(
        fontSize: 22,
        color: AppColor.primaryDarkBlue,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  bool checkEventComing(Event event) {
    var startDateEvent =
        DateTime.fromMillisecondsSinceEpoch(event.startDate?.toInt() ?? 0);
    var endDateEvent =
        DateTime.fromMillisecondsSinceEpoch(event.endDate?.toInt() ?? 0);
    if (endDateEvent.isAfter(_currentDay) &&
            startDateEvent.isBefore(_currentDay) ||
        DateTime(_currentDay.year, _currentDay.month, _currentDay.day) ==
            DateTime(
              startDateEvent.year,
              startDateEvent.month,
              startDateEvent.day,
            ) ||
        DateTime(_currentDay.year, _currentDay.month, _currentDay.day) ==
            DateTime(
              endDateEvent.year,
              endDateEvent.month,
              endDateEvent.day,
            )) {
      return true;
    } else {
      return false;
    }
  }

  bool checkEventHappening(Event event) {
    DateTime dateTimeNow = DateTime.now();
    var startDateEvent =
        DateTime.fromMillisecondsSinceEpoch(event.startDate?.toInt() ?? 0);
    var endDateEvent =
        DateTime.fromMillisecondsSinceEpoch(event.endDate?.toInt() ?? 0);
    if (endDateEvent.isAfter(dateTimeNow) &&
            startDateEvent.isBefore(dateTimeNow) ||
        DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day) ==
            DateTime(
              startDateEvent.year,
              startDateEvent.month,
              startDateEvent.day,
            ) ||
        DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day) ==
            DateTime(
              endDateEvent.year,
              endDateEvent.month,
              endDateEvent.day,
            )) {
      return true;
    } else {
      return false;
    }
  }
}
