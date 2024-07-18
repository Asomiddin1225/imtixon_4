// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:imtixon_4/models/event.dart';

// class FirebaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final _storage = FirebaseStorage.instance.ref();

//   Future<void> addEvent(Event event, File file) async {
//     final data = _storage.child("${event.name}-${UniqueKey()}");
//     final response = await data.putFile(file);
//     event.imageUrl = await data.getDownloadURL();
//     await _firestore.collection('events').add(event.toMap());
//   }

//   Future<List<Event>> getUserEvents() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       QuerySnapshot snapshot = await _firestore
//           .collection('events')
//           .where('userId', isEqualTo: user.uid)
//           .get();
//       return snapshot.docs
//           .map((doc) =>
//               Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//           .toList();
//     }
//     return [];
//   }

//   Future<List<Event>> searchEventsByName(String name) async {
//     QuerySnapshot snapshot = await _firestore
//         .collection('events')
//         .where('name', isEqualTo: name)
//         .get();
//     return snapshot.docs
//         .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//         .toList();
//   }

//   Future<List<Event>> searchEventsByLocation(String location) async {
//     QuerySnapshot snapshot = await _firestore
//         .collection('events')
//         .where('location', isEqualTo: location)
//         .get();
//     return snapshot.docs
//         .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//         .toList();
//   }

//   Future<List<Event>> getEventsWithin7Days() async {
//     DateTime now = DateTime.now();
//     DateTime sevenDaysFromNow = now.add(Duration(days: 7));
//     QuerySnapshot snapshot = await _firestore
//         .collection('events')
//         .where('date', isGreaterThanOrEqualTo: now.toIso8601String())
//         .where('date', isLessThanOrEqualTo: sevenDaysFromNow.toIso8601String())
//         .get();
//     return snapshot.docs
//         .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//         .toList();
//   }

//   Future<void> updateEvent(Event event, File? file) async {
//     await _firestore.collection('events').doc(event.id).update(event.toMap());
//   }

//   Future<void> deleteEvent(String eventId) async {
//     await _firestore.collection('events').doc(eventId).delete();
//   }
// }






// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:imtixon_4/models/event.dart';

// class FirebaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final _storage = FirebaseStorage.instance.ref();

//   Future<void> addEvent(Event event, File file) async {
//     final data = _storage.child("${event.name}-${UniqueKey()}");
//     final response = await data.putFile(file);
//     event.imageUrl = await data.getDownloadURL();
//     await _firestore.collection('events').add(event.toMap());
//   }

//   Future<List<Event>> getUserEvents() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       QuerySnapshot snapshot = await _firestore
//           .collection('events')
//           .where('userId', isEqualTo: user.uid)
//           .get();
//       return snapshot.docs
//           .map((doc) =>
//               Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//           .toList();
//     }
//     return [];
//   }

//   Future<List<Event>> searchEventsByName(String name) async {
//     QuerySnapshot snapshot = await _firestore
//         .collection('events')
//         .where('name', isEqualTo: name)
//         .get();
//     return snapshot.docs
//         .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//         .toList();
//   }

//   Future<List<Event>> searchEventsByLocation(String location) async {
//     QuerySnapshot snapshot = await _firestore
//         .collection('events')
//         .where('location', isEqualTo: location)
//         .get();
//     return snapshot.docs
//         .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//         .toList();
//   }

//   Future<List<Event>> getEventsWithin7Days() async {
//     DateTime now = DateTime.now();
//     DateTime sevenDaysFromNow = now.add(Duration(days: 7));
//     QuerySnapshot snapshot = await _firestore
//         .collection('events')
//         .where('date', isGreaterThanOrEqualTo: now.toIso8601String())
//         .where('date', isLessThanOrEqualTo: sevenDaysFromNow.toIso8601String())
//         .get();
//     return snapshot.docs
//         .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
//         .toList();
//   }

//   Future<void> updateEvent(Event event, File? file) async {
//     await _firestore.collection('events').doc(event.id).update(event.toMap());
//   }

//   Future<void> deleteEvent(String eventId) async {
//     await _firestore.collection('events').doc(eventId).delete();
//   }
// }













import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:imtixon_4/models/event.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance.ref();

  Future<void> addEvent(Event event, File file) async {
    final data = _storage.child("${event.name}-${UniqueKey()}");
    final response = await data.putFile(file);
    event.imageUrl = await data.getDownloadURL();
    await _firestore.collection('events').add(event.toMap());
  }

  Future<List<Event>> getUserEvents() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: user.uid)
          .get();
      return snapshot.docs
          .map((doc) =>
              Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    }
    return [];
  }

  Future<List<Event>> searchEventsByName(String name) async {
    QuerySnapshot snapshot = await _firestore
        .collection('events')
        .where('name', isEqualTo: name)
        .get();

        
    return snapshot.docs
        .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<List<Event>> searchEventsByLocation(String location) async {
    QuerySnapshot snapshot = await _firestore
        .collection('events')
        .where('location', isEqualTo: location)
        .get();
    return snapshot.docs
        .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<List<Event>> getEventsWithin7Days() async {
    DateTime now = DateTime.now();
    DateTime sevenDaysFromNow = now.add(Duration(days: 7));
    QuerySnapshot snapshot = await _firestore
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: now.toIso8601String().split('T')[0])
        .where('date', isLessThanOrEqualTo: sevenDaysFromNow.toIso8601String().split('T')[0])
        .get();
    return snapshot.docs
        .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateEvent(Event event, File? file) async {
    await _firestore.collection('events').doc(event.id).update(event.toMap());
  }

  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }
}
