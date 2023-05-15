// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // to hide the keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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

        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.1),
            child: SingleChildScrollView(
              physics: PageScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // showing user profile image
                    SizedBox(
                      height: mq.height * 0.01,
                    ),
                    Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.3),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * 0.3,
                                  height: mq.height * 0.3,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.3),
                                child: CachedNetworkImage(
                                  width: mq.height * 0.3,
                                  height: mq.height * 0.3,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            onPressed: () {
                              _showBottomSheet();
                            },
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
                      onSaved: (val) => APIs.me.name = val ?? "",
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: "e.g. Happy Singh",
                        label: const Text("Name"),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * 0.02,
                    ),
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? "",
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: "e.g. Feeling Happy",
                        label: const Text("About"),
                      ),
                    ),

                    // now showing elevated button to update the text
                    SizedBox(
                      height: mq.height * 0.03,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackBar(
                                context, "Profile updated successfully!");
                          });
                        }
                      },
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
        ),
      ),
    );
  }

  // bottom sheet for picking a profile photo for user
  _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(mq.width * 0.05),
            topRight: Radius.circular(mq.width * 0.05),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * 0.04, bottom: mq.height * 0.1),
            children: [
              // pick profile picture label
              const Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),

              SizedBox(
                height: mq.height * 0.03,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // to pick image from gallery
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      fixedSize: Size(mq.width * 0.3, mq.height * 0.15),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        log("Image Path : ${image.path}  Mine type : ${image.mimeType}");
                        setState(() {
                          _image = image.path;
                        });

                        APIs.updateProfilePicture(File(_image!));
                        // for hiding model bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset("assets/images/add_image.png"),
                  ),

                  // to pick image from camera
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      fixedSize: Size(mq.width * 0.3, mq.height * 0.15),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        log("Image Path : ${image.path}  Mine type : ${image.mimeType}");
                        setState(() {
                          _image = image.path;
                        });

                        APIs.updateProfilePicture(File(_image!));

                        // for hiding model bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset("assets/images/camera.png"),
                  ),
                ],
              )
            ],
          );
        });
  }
}
