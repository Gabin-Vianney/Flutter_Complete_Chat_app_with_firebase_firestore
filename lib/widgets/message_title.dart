import 'package:flutter/material.dart';

class MessageTitlePage extends StatefulWidget {
  final String message;
  final String sender;
  final bool sendByMe;

  const MessageTitlePage(
      {super.key,
      required this.message,
      required this.sender,
      required this.sendByMe});
  @override
  State<MessageTitlePage> createState() => MessageTitlePageState();
}

class MessageTitlePageState extends State<MessageTitlePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sendByMe ? 0 : 24,
        right: widget.sendByMe ? 24 : 0,
      ),
      alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
         color: widget.sendByMe ? const Color(0xffee7b64) : Colors.grey[700],
          borderRadius: widget.sendByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.sender.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                )),
            const SizedBox(
              height: 7,
            ),
            Text(widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}
