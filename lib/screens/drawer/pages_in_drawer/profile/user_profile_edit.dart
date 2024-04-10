import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/user_profile_bloc/user_profile_bloc.dart';
import 'user_profile_refactor.dart';

class UserProfileEdit extends StatefulWidget {
  UserProfileEdit({super.key});

  @override
  State<UserProfileEdit> createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController mobileNumberController;

  final items = ["select a value", "MEN", "WOMEN"];
  String? gender;
  var dd;
  var mm;
  var yyyy;
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    mobileNumberController = TextEditingController();
    gender = items[0];
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final userId = user.uid;
    final firestore = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("personal_details")
        .doc(user.email)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(
          'EDIT PROFILE',
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
                    debugPrint("issue is here!!!");
                    // return Center(
                    //   child: CircularProgressIndicator(),
                    // );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  final data = snapshot.data;
                  final Map<String, dynamic> dateMap =
                      snapshot.data!["date"] ?? "";
                  firstNameController.text = data!["first_name"];
                  lastNameController.text = data["last_name"];
                  mobileNumberController.text = data["phone_number"];
                  gender = data["gender"];
                  dd = dateMap["day"];
                  mm = dateMap["month"];
                  yyyy = dateMap["year"];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      UserProfileTextFormField(
                        text: "First Name",
                        controller: firstNameController,
                      ),
                      buildSizedBox(),
                      UserProfileTextFormField(
                        text: "Last Name",
                        controller: lastNameController,
                      ),
                      buildSizedBox(),
                      UserProfileTextFormField(
                        text: "Mobile Number",
                        controller: mobileNumberController,
                      ),
                      buildSizedBox(),
                      Container(
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            BlocBuilder<UserProfileBloc, UserProfileState>(
                              builder: (context, state) {
                                if (state is GenderSelectedState) {
                                  gender = state.gender;
                                }
                                return DropdownButton(
                                    icon: Icon(Icons.arrow_drop_down_outlined),
                                    hint: Text("Select Gender"),
                                    value: gender,
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      context.read<UserProfileBloc>().add(
                                          OnSelectGenderEvent(gender: value));
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                      buildSizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 0,
                          ),
                          BlocBuilder<UserProfileBloc, UserProfileState>(
                            builder: (context, state) {
                              if (state is DateOfBirthSelectedState) {
                                dd = state.selectedDate.day;
                                mm = state.selectedDate.month;
                                yyyy = state.selectedDate.year;
                              }
                              return Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 45,
                                      child: Center(
                                          child: Text(dd?.toString() ?? "dd")),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Container(
                                        width: 60,
                                        height: 45,
                                        child: Center(
                                            child:
                                                Text(mm?.toString() ?? "mm")),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      height: 45,
                                      child: Center(
                                          child:
                                              Text(yyyy?.toString() ?? "yyyy")),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          IconButton(
                              onPressed: () {
                                context
                                    .read<UserProfileBloc>()
                                    .add(OnCalenderIconClickedEvent(
                                      context: context,
                                    ));
                              },
                              icon: Icon(Icons.date_range)),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: screenWidth * .5,
                        height: 45,
                        child: BlocListener<UserProfileBloc, UserProfileState>(
                          listener: (context, state) {
                            if (state is UserDetailAddedState) {
                              Navigator.pop(context);
                            }
                          },
                          child: ElevatedButton(
                            onPressed: () {
                              if (firstNameController.text.isNotEmpty &&
                                  mobileNumberController.text.isNotEmpty &&
                                  lastNameController.text.isNotEmpty &&
                                  gender != "select a value" &&
                                  dd != null &&
                                  mm != null &&
                                  yyyy != null) {
                                context.read<UserProfileBloc>().add(
                                    OnAddUserDetailsEvent(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        number: mobileNumberController.text,
                                        gender: gender!,
                                        day: dd,
                                        month: mm,
                                        year: yyyy));
                              } else {
                                debugPrint(gender);
                                if (gender != "select a value") {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content:
                                            Text("Please select your gender!"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("OK"))
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Mandatory fields can't be empty!"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("OK"))
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            child: Text("Add details"),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  SizedBox buildSizedBox() => SizedBox(height: 15);
}
