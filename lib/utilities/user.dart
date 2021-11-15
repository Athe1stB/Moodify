import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile {
  String name = '';
  int age = 0;

  static dynamic currentUserSigned = FirebaseAuth.instance.currentUser;
  String email = currentUserSigned.email.toString();

  Profile(this.name, this.age);

  Future<bool> addToCloud() async {
    CollectionReference userList =
        FirebaseFirestore.instance.collection('Users');

    bool toreturn = true;

    await userList.doc(email).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists)
        toreturn = false;
      else
        toreturn = true;
    });

    if (toreturn) {
      if (name == null) name = 'Doctor';
      if (age == null) age = 0;

      dynamic favChannel = [];
      Map<String, dynamic> favVideos = {
        'surprise': [],
        'sad': [],
        'happy': [],
        'fear': [],
        'disgust': [],
        'angry': [],
        'trending': [],
        'neutral': []
      };

      await userList.doc(email).set({
        'name': name,
        'age': age,
        'email': email,
        'favChannel': favChannel,
        'favVideos': favVideos,
      });
    }

    return toreturn;
  }
}
