import 'package:flutter/material.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/message.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({
    super.key,
    required this.message,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  // sender or other user message
  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // message content
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * 0.04,
              vertical: mq.height * 0.01,
            ),
            padding: EdgeInsets.all(mq.width * 0.04),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                // making borders curved
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Text(widget.message.msg),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(
            widget.message.sent,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * 0.04,
            ),
            // double tick blue for message read
            const Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 20,
            ),

            // for adding some space
            const SizedBox(
              width: 2,
            ),
            //read time
            Text(
              "${widget.message.read}12:00 PM",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
          ],
        ),

        // message content
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * 0.04,
              vertical: mq.height * 0.01,
            ),
            padding: EdgeInsets.all(mq.width * 0.04),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                // making borders curved
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Text(widget.message.msg),
          ),
        ),
      ],
    );
  }
}
