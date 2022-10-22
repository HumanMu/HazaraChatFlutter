// import 'package:flutter/material.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:intl/intl.dart';

// import '../models/message.dart';


// class ChatRoom extends StatefulWidget {
//   const ChatRoom({super.key});

//   @override
//   State<ChatRoom> createState() => _ChatRoomState();
// }

// class _ChatRoomState extends State<ChatRoom> {

//   final _messageController = TextEditingController();

//   List<Message> messages = [
//     Message(text: 'hi', date: DateTime.now().subtract(const Duration(minutes: 1)), 
//     isSentByMe: false)
//   ].reversed.toList();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(" اتاق بحث ", style: TextStyle(fontSize: 35),),
//         backgroundColor: Colors.redAccent,
//         centerTitle: true,
//       ),

//       body: _body(context),
      
//     );
//   }

//   Widget _body(context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: GroupedListView<Message, DateTime>(
//               padding: const EdgeInsets.all(10),
//               reverse: true,
//               order: GroupedListOrder.DESC,
//               useStickyGroupSeparators: true,
//               floatingHeader: true,
//               elements: messages,
//               groupBy: (message) => DateTime(
//                 message.date.year,
//                 message.date.month,
//                 message.date.day,
//               ),
//               groupHeaderBuilder: (Message message) => SizedBox(
//                 height: 35,
//                 child: Card(
//                   color: Theme.of(context).primaryColor, 
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Text( 
//                       DateFormat.yMMMd().format(message.date),
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),

//                 ),
//               ),
//               itemBuilder: (context, Message message) => Align( 
//                 alignment: message.isSentByMe
//                 ? Alignment.centerLeft
//                 : Alignment.centerRight,
//                 child: Card(
//                   elevation: 8,
//                   child: Padding(
//                     padding: const EdgeInsets.all(15),
//                     child: Text(message.text),

//                   ),
//               )),
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.only(bottom: 3, right: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 SizedBox(height: 40, width: 40, child: _sendButton()),
//                 Expanded(child: _writingBox(_messageController),),
//               ],
//             ),
//           )
//           // Container(child: Container(),),

//         ]
//     );
//   }

//   Widget _writingBox( TextEditingController messageController ) {
    

//     return Container(
//       alignment: Alignment.bottomCenter,
//       height: 35,
//       color: Colors.grey[500],
//       child: TextField(
//         textAlign: TextAlign.right,
//         textAlignVertical: TextAlignVertical.center,
//         controller: messageController,
//         decoration: const InputDecoration(
//           contentPadding: EdgeInsets.only( right: 15, left: 5, bottom: 10),
//           hintText: ' ... پیام خود را اینجا بنویس'
//         ),
//       ),
//     );

//   }

//   Widget _sendButton() {
//     return InkWell(
//       onTap: _sendMessage,
//       child: Image.asset('assets/icons/sendButtonIcon.png'),
//     );
//   }


//   void _sendMessage() {
//     final message = Message(
//       text: _messageController.text, 
//       date: DateTime.now(), 
//       isSentByMe: true,
//       );
//   }
// }


// //https://www.youtube.com/watch?v=FTju8w4zEno
// //https://www.youtube.com/watch?v=eGhvL082-Pc