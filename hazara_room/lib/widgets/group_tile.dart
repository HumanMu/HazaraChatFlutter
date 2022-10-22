import 'package:flutter/material.dart';
import 'package:hazara_room/screens/chat_page.dart';
import 'package:hazara_room/widgets/text_widgets.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String grouId;
  final String groupName;

  const GroupTile({Key? key,
    required this.grouId,
    required this.groupName, 
    required this.userName
  }) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {
        navigateToAnotherScreen(context, ChatPage(
          groupId: widget.grouId, 
          groupName: widget.groupName, 
          userName: widget.userName,
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(radius: 25,
          backgroundColor: Colors.red,
          child: Text(
            widget.groupName.substring(0, 1).toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),),
          title: Text(widget.groupName, 
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text("عضو  شو ${widget.userName} ",
            style: const TextStyle( fontSize: 15),
          ),
        ),
      ),
    );
      
  }
}