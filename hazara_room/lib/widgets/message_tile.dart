import 'package:flutter/material.dart';
class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sendByMe;

  const MessageTile({
    super.key,
    required this.message,
    required this.sender,
    required this.sendByMe,
    
  });

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4, bottom: 4,
        left: widget.sendByMe ? 0 : 24,
        right: widget.sendByMe ? 24 : 0, 
      ),
      alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sendByMe 
          ? const EdgeInsets.only(left: 30) 
          : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20 ),
        decoration: BoxDecoration(
          borderRadius: widget.sendByMe? const BorderRadius.only(
            topLeft: Radius.circular(7),
            topRight: Radius.circular(7),
            bottomLeft: Radius.circular(7),
          ) : const BorderRadius.only(
            topLeft: Radius.circular(7),
            topRight: Radius.circular(7),
            bottomLeft: Radius.circular(7),
          ),
          color: widget.sendByMe ? Colors.green : Colors.red,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: -0.2),
            ),
            const SizedBox(height: 8,),
            Text(widget.message, textAlign: TextAlign.center, 
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white

              ),
            ),
          ],
        ),
      ),
    );
  }
}