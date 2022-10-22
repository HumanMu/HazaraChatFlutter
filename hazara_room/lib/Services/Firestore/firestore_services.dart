import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final String? userId;

  FirestoreService({this.userId});

  // reference to the firestore collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");
  final CollectionReference friendsCollection = FirebaseFirestore.instance.collection("friends");
  

  // Saving user data
  Future saveUserData (String fullname, String email ) async {
    return await userCollection.doc(userId).set({
      "fullname": fullname,
      "email" : email,
      "groups" : [],
      "friends": [],
      "profilePic" : "",
      "uid" : userId,

    });
  }

  // Retriving user data
  Future getUserData( String email) async {
    QuerySnapshot snapshot = await userCollection.where(  // Return user information that has this email from firestore
      "email", isEqualTo: email).get();
    return snapshot;
  }

  getUserGroups () async {
    return userCollection.doc(userId).snapshots();
  }



  // creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName" : groupName,
      "groupIcon" : "",
      "admin" : "${id}_$userName",
      "members" : [],
      "groupId" : "",
      "recentMessage" : "",
      "recentMessageSender" : "",
    });

    // Update group members
    await groupDocumentReference.update ({
      "members" : FieldValue.arrayUnion(["${userId}_$userName"]),
      "groupId" : groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(userId);
    return await userDocumentReference.update({
      "groups" : FieldValue.arrayUnion((["${groupDocumentReference.id}_$groupName"]))
    });   
  }

  // Getting the chats
  getChat(String groupId ) async {
    return groupCollection.doc(groupId)
    .collection("messages")
    .orderBy("time")
    .snapshots();
  }

  Future getGroupAdmin (String groupId) async {
    DocumentReference docRef = groupCollection.doc(groupId);
    DocumentSnapshot docSnap = await docRef.get();
    return docSnap["admin"];
  }

  getGroupMember(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }


  // Returning search result
  searchByGroupName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // A function that checks if user pressed joined button to a group 
  Future <bool> checkIfUserJoined(String groupName, String groupId, String userName) async {
    DocumentReference udr = userCollection.doc(userId);
    DocumentSnapshot ds = await udr.get();

    List<dynamic> groups = await ds['groups'];
    if(groups.contains("${groupId}_$groupName")) {
      return true;
    }
    else {
      return false;
    }
  }

  // Toggle between join or leave a group 
  Future toggleGroupMembership(String groupId, String userName, String groupName) async {
    DocumentReference udr = userCollection.doc(userId);
    DocumentReference gdr = groupCollection.doc(groupId);

    DocumentSnapshot ds = await udr.get();
    List<dynamic> groups = await ds['groups'];

    // If the user is already a member of the group removie it
    if(groups.contains("${groupId}_$groupName")) {
      await udr.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await gdr.update({
        "members": FieldValue.arrayRemove(["${userId}_$userName"])
      });
    }
    else {
      await udr.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await gdr.update({
        "members": FieldValue.arrayUnion(["${userId}_$userName"])
      });
    }
  }

  // Send message
  sendMessage(String groupId, Map<String, dynamic>chatMessageData ) {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime" : chatMessageData['time'].toString(),
    });
  }


}
