// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testapi/views/login_screen.dart';
import 'package:testapi/widgets/my_button.dart';
import 'package:testapi/widgets/snackbar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  Map<String, dynamic>? userData;
  Uint8List? profileImageBytes;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user == null) return;
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance
              .collection("userData")
              .doc(user!.uid)
              .get();
      if (documentSnapshot.exists) {
        userData = documentSnapshot.data() as Map<String, dynamic>?;
        if (userData?['photoBase64'] != null) {
          profileImageBytes = base64Decode(userData!['photoBase64']);
        }
        isLoading = false;
      }
    }
     catch (e) {
      showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Erreur'),
      content: Text("Erreur lors du chargement des données : $e"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );

      // print(e.toString());
      // showSnackBar(context, "Error fetching user data : $e");
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  // Future<void> updateProfileImage(Uint8List imageBytes) async {
  //   if (user == null) return;
  //   try {
  //     String base64Image = base64Encode(imageBytes);
  //     // ensure the  photobase64 is only update when no-null
  //     await FirebaseFirestore.instance
  //         .collection("userData")
  //         .doc(user!.uid)
  //         .set({"photoBase64": base64Image}, SetOptions(merge: true));
  //     setState(() {
  //       profileImageBytes = imageBytes;
  //     });
  //     showSnackBar(context, "Profile image updated successfully");
  //   } catch (e) {
  //     showSnackBar(context, "FAILED TO UPDATE PROFILE IMAGE : $e");
  //   }
  // }

Future<void> updateProfileImage(Uint8List imageBytes) async {
  if (user == null) return;

  setState(() => isLoading = true);

  try {
    String base64Image = base64Encode(imageBytes);
    await FirebaseFirestore.instance
        .collection("userData")
        .doc(user!.uid)
        .set({"photoBase64": base64Image}, SetOptions(merge: true));

    setState(() {
      profileImageBytes = imageBytes;
      isLoading = false;
    });

    showSnackBar(context, "Profile image updated successfully");
  } catch (e) {
    setState(() => isLoading = false);
    showSnackBar(context, "FAILED TO UPDATE PROFILE IMAGE : $e");
  }
}


  // pick image from gallery
  Future<void> pickImageFromGallery() async {
    final returnImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (returnImage == null) return;
    // convert the image  to bytes
    final imageBytes = await returnImage.readAsBytes();
    if (!mounted) return;
    // update profile image with the new image
    await updateProfileImage(imageBytes);
  }

  // for signOut
  // Future<void> signOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const LoginScreen()),
  //   );
  // }
Future<void> signOut() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Déconnexion'),
      content: const Text('Voulez-vous vraiment vous déconnecter ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Oui'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : userData == null
              ? Center(child: Text("No user data found"))
              : Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        radius: 60,
                        backgroundImage:
                            NetworkImage(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                                )
                                as ImageProvider,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 16,
                            child: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                  
                    const SizedBox(height: 15),
                    Text(
                      userData?['nom'],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),

                    Text(
                      "Score : ${userData?['score'] * 120}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyButton(
                            onTap: signOut,
                            buttontext: "Sign Out",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
