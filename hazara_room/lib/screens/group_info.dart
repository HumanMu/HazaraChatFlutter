import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazara_room/Services/Firestore/firestore_services.dart';
import 'package:hazara_room/screens/home_page.dart';
import 'package:hazara_room/widgets/text_widgets.dart';


class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;

  const GroupInfo({ Key? key,
    required this.groupId,
    required this.groupName,
    required this.adminName,

  }) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  @override
  void initState() {
    getMember();
    super.initState();
  }
  getMember() async {
    FirestoreService(userId: FirebaseAuth.instance.currentUser!.uid)
    .getGroupMember(widget.groupId).then((val) {
      setState(() {
        members = val;
      });
    });
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
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
        title: const Text("درباره این گروه", textDirection: TextDirection.rtl,),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context, 
                builder: (context) {
                  return AlertDialog(
                    title: const Text("خروج "),
                    content: const Text("مطمئن هستی از اینکه از گروه خارج میشوی؟",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                    actions: [
                      IconButton(onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel_presentation, color: Colors.red,),),
                      IconButton(
                        onPressed: () async {
                          await FirestoreService(userId: FirebaseAuth.instance.currentUser!.uid)
                          .toggleGroupMembership(widget.groupId, getName(widget.adminName), widget.groupName).whenComplete(() {
                            navigateAndReplaceCurrentScreen(context, const HomePage());
                          });
                        }, icon: const Icon(Icons.done_outline, color: Colors.green,)),
                  ],);
                }
              );
            }, 
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Text(
                    widget.groupName.substring(0,1).toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,

                    ),
                  ),                  
                ),
                const SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("گروه: ${widget.groupName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text("رئیس گروه: ${getName(widget.adminName)}",
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  
                  ],
                ),
               ],
            ),
          ),
          memberList(),
        ],      
      )),

    );
  }

  memberList () {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data["members"] != null) {
            if(snapshot.data["members"].length != 0){
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red,
                        child: Text(
                          getName(snapshot.data["members"][index]).substring(0,1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(getName(snapshot.data["members"][index])),
                      subtitle: Text(getId(snapshot.data["members"][index])),
                    ),
                  );
                }
              );
            }
            else {
              return const Center(
                child: Text("هیچ عضوی  پیدا نشد "),
              );
            }
          }
          else{
            return const Center(
              child: Text("هیچ عضوی  پیدا نشد "),
            );
          }
        }
        else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
      }
    );
  }
}