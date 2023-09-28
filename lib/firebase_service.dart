import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> addComment(String videoId, String username, String text) async {
  CollectionReference comments = FirebaseFirestore.instance.collection('comments');
  await comments.add({
    'videoId': videoId,
    'username': username,
    'text': text,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

Future<QuerySnapshot<Map<String, dynamic>>> getCommentsForVideo(String videoId) async {
  CollectionReference comments = FirebaseFirestore.instance.collection('comments');
  Query<Map<String, dynamic>> query = comments
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snap, _) => snap.data()!,
        toFirestore: (data, _) => data,
      )
      .where('videoId', isEqualTo: videoId)
      .orderBy('timestamp', descending: true);
  return await query.get();
}



Future<String> uploadVideo(File videoFile, String videoName) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child('videos/$videoName');
  UploadTask uploadTask = ref.putFile(videoFile);
  await uploadTask;
  return await ref.getDownloadURL();
}

String generateVideoId() {
  final Random _random = Random();
  final int length = 10;
  const String _chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => _chars.codeUnitAt(_random.nextInt(_chars.length)),
  ));
}
