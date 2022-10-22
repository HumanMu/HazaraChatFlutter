import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hazara_room/Services/Firestore/firestore_services.dart';
import 'package:hazara_room/screens/group_info.dart';
import 'package:hazara_room/widgets/message_tile.dart';
import 'package:hazara_room/widgets/text_widgets.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage({
    Key? key, 
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageBox = TextEditingController();
  Stream <QuerySnapshot> ? chats;
  String admin = "";


    @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    FirestoreService().getChat(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });

    FirestoreService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              navigateToAnotherScreen(context, GroupInfo(
                groupId: widget.groupId,
                groupName: widget.groupName,
                adminName: admin,
              ));
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          chatMessage(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      controller: messageBox,
                      style: const TextStyle(
                        color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "پیام خود را اینجا بنویس ...",
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                                                  
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                  
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ],)
    );
  }

  chatMessage() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData 
          ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: snapshot.data.docs[index]['message'], 
                sender: snapshot.data.docs[index]['sender'], 
                sendByMe: widget.userName == snapshot.data.docs[index]['sender'],
              );
            },
        ) : Container();
      }
    
    );
  }

  sendMessage() {
    if(messageBox.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageBox.text,
        "sender" : widget.userName,
        "time" : DateTime.now().millisecondsSinceEpoch,
      };
      FirestoreService().sendMessage(widget.groupId, chatMessageMap );
      setState(() {
        messageBox.clear();
      });
    }
  }
}