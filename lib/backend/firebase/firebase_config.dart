import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDToZ4u67wvjP5JYNhzTbuYBh6xLwjSE48",
            authDomain: "umatna-df200.firebaseapp.com",
            projectId: "umatna-df200",
            storageBucket: "umatna-df200.appspot.com",
            messagingSenderId: "451108032570",
            appId: "1:451108032570:web:5587cc5694d78ac96fa503",
            measurementId: "G-FY1T7K9LJD"));
  } else {
    await Firebase.initializeApp();
  }
}
