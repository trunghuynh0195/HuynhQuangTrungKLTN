import 'package:app_admin_attendance/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';

class ManagerEventBloC {
  final _listEvent = BehaviorSubject<List<Event>>();
  Stream<List<Event>> get listEventStream => _listEvent.stream;

  List<Map<String, dynamic>> dataEventsResponseFromFireCloud = [];

  Future<void> getListEvents() async {
    await FirebaseFirestore.instance
        .collection('Events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        dataEventsResponseFromFireCloud.add(doc.data() as Map<String, dynamic>);
      }
    });
    List<Event> list = dataEventsResponseFromFireCloud
        .cast<Map<String, dynamic>>()
        .map<Event>((e) => Event.fromJson(e))
        .toList();
    _listEvent.add(list);
  }

  void dispose() {
    _listEvent.close();
  }
}
