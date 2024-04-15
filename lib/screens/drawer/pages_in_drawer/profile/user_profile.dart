import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuni/screens/drawer/pages_in_drawer/profile/user_profile_add.dart';
import 'package:tuni/screens/drawer/pages_in_drawer/profile/user_profile_edit.dart';
import 'package:tuni/screens/drawer/pages_in_drawer/profile/user_profile_refactor.dart';

class UserProfile extends StatelessWidget {
  UserProfile({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final userId = user!.uid;
    final userEmail = user!.email;
    final firestore = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("personal_details")
        .doc(userEmail!)
        .snapshots();
    String firstName;
    String lastName;
    String number;
    String gender;
    int day;
    int month;
    int year;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(
          'MY PROFILE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: StreamBuilder<DocumentSnapshot>(
              stream: firestore,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return SizedBox(
                      height: 500,
                      child: Center(child: Text("No Personal data added!")));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text(" ");
                } else {
                  final data = snapshot.data!;
                  firstName = data["name"];
                  // lastName = data["last_name"];
                  // number = data['phone_number'];
                  // gender = data["gender"];
                  // Map<String, dynamic> dateMap = data["date"];
                  // day = dateMap["day"];
                  // month = dateMap["month"];
                  // year = dateMap["year"];
                  // final dob = "$day/$month/$year";

                  return Container(
                    height: screenHeight * .8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          userDetailsHeadingText(text: "Email"),
                          SizedBox(height: 5),
                          userDetailsDisplayingText(user!.email),
                          SizedBox(height: 20),
                          userDetailsHeadingText(text: "First name"),
                          SizedBox(height: 5),
                          userDetailsDisplayingText(firstName),
                          SizedBox(height: 20),
                          userDetailsHeadingText(text: "Last name"),
                          SizedBox(height: 5),
                          // userDetailsDisplayingText(lastName),
                          SizedBox(height: 20),
                          userDetailsHeadingText(text: "Date of birth"),
                          SizedBox(height: 5),
                          // userDetailsDisplayingText(dob),
                          SizedBox(height: 20),
                          userDetailsHeadingText(text: "Number"),
                          SizedBox(height: 5),
                          // userDetailsDisplayingText(number),
                          SizedBox(height: 20),
                          userDetailsHeadingText(text: "Gender"),
                          SizedBox(height: 5),
                          // userDetailsDisplayingText(gender),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: StreamBuilder<DocumentSnapshot>(
        stream: firestore,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return BottomAppBar(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return BottomAppBar(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return BottomAppBar(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileAdd()));
                },
                child: Text("Add Detail"),
              ),
            );
          } else {
            return BottomAppBar(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileEdit()));
                },
                child: Text("Edit Details"),
              ),
            );
          }
        },
      ),
    );
  }

  SizedBox buildSizedBox() => SizedBox(height: 15);
}
