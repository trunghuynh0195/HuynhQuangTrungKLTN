import 'package:app_admin_attendance/bloc/manager_event_bloc.dart';
import 'package:app_admin_attendance/models/event.dart';
import 'package:app_admin_attendance/screens/add_event.dart';
import 'package:app_admin_attendance/screens/event_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';

class ManagerEvent extends StatefulWidget {
  const ManagerEvent({Key? key}) : super(key: key);

  @override
  State<ManagerEvent> createState() => _ManagerEventState();
}

class _ManagerEventState extends State<ManagerEvent> {
  final ManagerEventBloC bloC = ManagerEventBloC();

  final user = auth.FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    bloC.getListEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Hello ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.black)),
                          TextSpan(
                              text: '${user?.email}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.blue)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Explore ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.black)),
                          TextSpan(
                              text: 'New Events',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: GestureDetector(
                  onTap: () => Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const AddEvent(),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black)),
                    child: const Padding(
                        padding: EdgeInsets.all(1), child: Icon(Icons.add)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: StreamBuilder<List<Event>>(
              stream: bloC.listEventStream,
              builder: (context, snapshot) {
                List<Event> listEvent = snapshot.data ?? [];
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (listEvent.isEmpty) {
                  return const Center(child: Text('No Events'));
                }
                listEvent.sort(
                  (a, b) => b.id!.compareTo(a.id!),
                );
                return ListView.builder(
                    itemCount: listEvent.length,
                    itemBuilder: (context, index) {
                      String startDate = DateFormat("dd MMM yyyy").format(
                          DateTime.fromMillisecondsSinceEpoch(
                              listEvent[index].startDate?.toInt() ?? 0));
                      String endDate = DateFormat("dd MMM yyyy").format(
                          DateTime.fromMillisecondsSinceEpoch(
                              listEvent[index].endDate?.toInt() ?? 0));
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => EventDetail(
                                  event: listEvent[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 2,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Colors.transparent)),
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildImage(listEvent[index]),
                                  Text(
                                    listEvent[index].name ?? '',
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 10, 53, 88),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_filled_rounded,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "$startDate - $endDate",
                                        style: const TextStyle(
                                            // color: Color(0xffFF2559),
                                            color: Colors.grey,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 2),
                                          child: Icon(
                                            Icons.location_on_rounded,
                                            color: Colors.grey,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Expanded(
                                          child: Text(
                                            listEvent[index].address ?? '',
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(Event event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CachedNetworkImage(
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
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
