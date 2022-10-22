

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazara_room/Services/Firestore/firestore_services.dart';
import 'package:hazara_room/Services/notification_services.dart';
import 'package:hazara_room/helper/helper_function.dart';
import 'package:hazara_room/screens/chat_page.dart';
import 'package:hazara_room/widgets/text_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool userIsAMemberOfTheGroup = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;


  @override
  void initState() {
    super.initState();
    getCurrentUserIdAndName();
  }

  getCurrentUserIdAndName() async {
    await HelperFunction.getUserName().then((val) {
      setState(() {
        userName = val!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String ind) {
    return ind.substring(ind.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text("جستجو", 
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15 ),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "جستجو به دنبال گروه ...",
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: TextStyle(color: Colors.white, fontSize: 15,),
                    
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  initiateSearch();
                },
                child: Container(
                  width: 45,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        isLoading? Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor ),
        ) : groupList(),
      ]),
      ),
    );
  }

  initiateSearch() async {
    if(searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await FirestoreService()
        .searchByGroupName(searchController.text)
        .then((snapshot) {
          setState(() {
            searchSnapshot = snapshot;
            isLoading = false;
            hasUserSearched = true;
          });
        });
    }
  }

  groupList() {
    return hasUserSearched 
      ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index) {
          return searchGroupTile(
            userName, 
            searchSnapshot!.docs[index]['groupId'],
            searchSnapshot!.docs[index]['groupName'],
            searchSnapshot!.docs[index]['admin'],
          );
        },
      
    ) : Container();
  }

  Widget searchGroupTile(String userName, String groupId, String groupName, String admin) {
     // Check if user already is a member of the group
    joinedGroupMembers(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.red,
        child: Text(groupName.substring(0,1).toUpperCase(), 
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      title: Text(groupName, style: const TextStyle(fontWeight: FontWeight.bold, )),
      subtitle: Text("رئیس گروه: ${getName(admin)}", 
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      trailing: InkWell(
        onTap: () async {
          await FirestoreService(userId: user!.uid)
          .toggleGroupMembership(groupId, userName, groupName);

          if(userIsAMemberOfTheGroup) {
            setState(() {
              userIsAMemberOfTheGroup = !userIsAMemberOfTheGroup;
            });
            if(mounted){
              showSnackBar(context, "با موفقیت عضو گروه شدی", Colors.green);
            }

            Future.delayed(const Duration(seconds: 2), () {
              navigateToAnotherScreen(context, ChatPage(
                groupId: groupId, 
                groupName: groupName, 
                userName: userName)
              );
            });
            
          }
          else {
            setState(() {
              userIsAMemberOfTheGroup = !userIsAMemberOfTheGroup;
            });
            if(mounted) {
              showSnackBar(context, "با موفقیت از گروه خارج شدی", Colors.red);
            }
          }
        },
        child: userIsAMemberOfTheGroup ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.lightGreen,
            border: Border.all(color: Colors.white, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text("خارج شو ", 
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,  
          ),
        ) 
        : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text("رئیس گروه: ", style: TextStyle(
              color: Colors.white, 
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }

  joinedGroupMembers(String userName, String groupId, String groupName, String admin) async {
    await FirestoreService(userId: user!.uid)
    .checkIfUserJoined(groupName, groupId, userName)
    .then((val){
      setState(() {
        userIsAMemberOfTheGroup = val;
      });
    });
  }
}