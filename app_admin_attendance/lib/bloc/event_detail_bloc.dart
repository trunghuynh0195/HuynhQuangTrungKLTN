import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EventDetailBloC {
  CollectionReference data = FirebaseFirestore.instance.collection('Events');
  Future<void> deleteEvent(String eventId) {
    return data
        .doc(eventId)
        .delete()
        .then((value) => print("Event Deleted"))
        .catchError((error) => print("Failed to delete event: $error"));
  }

//Share Image QR Code
  captureAndSharePng(renderObjectKey) async {
    List<String> pathImages = [];
    try {
      RenderRepaintBoundary boundary = renderObjectKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      pathImages.add('${tempDir.path}/image.png');
      await Share.shareFiles(pathImages);
      print('OK');
      // const channel = MethodChannel('channel:me.alfian.share/share');
      // channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }
}
