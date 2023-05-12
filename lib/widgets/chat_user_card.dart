import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:we_chat/main.dart";

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0.5,
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          // user profile picture
          leading: CircleAvatar(child: Icon(CupertinoIcons.person)),

          // user name
          title: Text("Demo User"),

          // user message
          subtitle: Text(
            "Last User Message",
            maxLines: 1,
          ),

          // user message time
          trailing: Text(
            "12:00 PM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
