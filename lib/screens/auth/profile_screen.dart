import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helpers/dialogs.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/auth/login_screen.dart';
import 'package:we_chat/widgets/chat_user_card.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        title: const Text("Profile Screen"),
      ),

      //floating Action Button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10),
        child: FloatingActionButton.extended(
          onPressed: () async {
            // for showing progress dialog
            Dialogs.showProgressBar(context);

            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                // for hiding progress Indicator
                Navigator.pop(context);

                // for moving to home screen
                Navigator.pop(context);

                // now replacing home screen to login screen
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              });
            });
          },
          backgroundColor: Colors.redAccent,
          icon: const Icon(Icons.logout),
          label: const Text("Logout"),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * 0.1),
        child: SingleChildScrollView(
          physics: PageScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            // showing user profile image
            SizedBox(
              height: mq.height * 0.01,
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.3),
                  child: CachedNetworkImage(
                    width: mq.height * 0.3,
                    height: mq.height * 0.3,
                    fit: BoxFit.fill,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: MaterialButton(
                    onPressed: () {},
                    color: Colors.white,
                    shape: CircleBorder(),
                    elevation: 1,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),

            // showing email of the user
            SizedBox(
              height: mq.height * 0.01,
            ),

            Text(
              widget.user.email,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            // now showing fields to edit user name and about

            SizedBox(
              height: mq.height * 0.05,
            ),

            TextFormField(
              initialValue: widget.user.name,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: "e.g. Happy Singh",
                label: const Text("Name"),
              ),
            ),
            SizedBox(
              height: mq.height * 0.02,
            ),
            TextFormField(
              initialValue: widget.user.about,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: "e.g. Feeling Happy",
                label: const Text("About"),
              ),
            ),

            // now showing elevated button to update the text
            SizedBox(
              height: mq.height * 0.03,
            ),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: Size(mq.width * 0.4, mq.height * 0.06)),
              icon: const Icon(Icons.edit),
              label: const Text(
                "UPDATE",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
