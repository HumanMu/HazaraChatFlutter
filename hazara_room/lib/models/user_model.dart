
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  // String email;
  // String name;
  // String? image;
  // Timestamp time;

  UserModel({ 
    required this.userId,
    // required this.email,
    // required this.name,
    // this.image,
    // required this.time,
    
  });

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    return UserModel(
      userId: snapshot['uid'],
      // email: snapshot['email'],
      // name: snapshot['name'],
      // image: snapshot['image'],
      // time: snapshot['date'],


    );
  }
}


// class UserModel {
//   String userId;

//   UserModel({ 
//     required this.userId,    
//   });
// }