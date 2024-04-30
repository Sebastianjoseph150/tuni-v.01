import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/user_profile_bloc/user_profile_bloc.dart';
import 'user_profile_refactor.dart';

class UserProfileEdit extends StatefulWidget {
  const UserProfileEdit({super.key});

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

    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              title: const Text(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: firestore,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // return Center(
                          //   child: CircularProgressIndicator(),
                          // );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        }
                        final DocumentSnapshot<Object?>? snapshotData =
                            snapshot.data;
                        if (snapshotData != null) {
                          final DocumentSnapshot<Object?> data = snapshotData;
                          final Map<String, dynamic>? dateMap =
                              snapshotData["date"];
                          firstNameController.text = data["first_name"];
                          lastNameController.text = data["last_name"];
                          mobileNumberController.text = data["phone_number"];
                          gender = data["gender"];
                          dd = dateMap?["day"];
                          mm = dateMap?["month"];
                          yyyy = dateMap?["year"];
                        } else {}

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
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
                            // Container(
                            //   decoration:
                            //       BoxDecoration(color: Colors.grey.shade300),
                            //   padding: const EdgeInsets.only(left: 20),
                            //   child: Row(
                            //     children: [
                            //       BlocBuilder<UserProfileBloc,
                            //           UserProfileState>(
                            //         builder: (context, state) {
                            //           if (state is GenderSelectedState) {
                            //             gender = state.gender;
                            //           }
                            //           return DropdownButton(
                            //               icon: const Icon(
                            //                   Icons.arrow_drop_down_outlined),
                            //               hint: const Text("Select Gender"),
                            //               value: gender,
                            //               items: items.map((String items) {
                            //                 return DropdownMenuItem(
                            //                   value: items,
                            //                   child: Text(items),
                            //                 );
                            //               }).toList(),
                            //               onChanged: (value) {
                            //                 context.read<UserProfileBloc>().add(
                            //                     OnSelectGenderEvent(
                            //                         gender: value));
                            //               });
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // buildSizedBox(),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     const SizedBox(
                            //       width: 0,
                            //     ),
                            //     BlocBuilder<UserProfileBloc, UserProfileState>(
                            //       builder: (context, state) {
                            //         if (state is DateOfBirthSelectedState) {
                            //           dd = state.selectedDate.day;
                            //           mm = state.selectedDate.month;
                            //           yyyy = state.selectedDate.year;
                            //         }
                            //         return Row(
                            //           children: [
                            //             Container(
                            //               width: 60,
                            //               height: 45,
                            //               decoration: BoxDecoration(
                            //                   color: Colors.grey.shade300,
                            //                   borderRadius:
                            //                       BorderRadius.circular(10)),
                            //               child: Center(
                            //                   child:
                            //                       Text(dd?.toString() ?? "dd")),
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.symmetric(
                            //                   horizontal: 10),
                            //               child: Container(
                            //                 width: 60,
                            //                 height: 45,
                            //                 decoration: BoxDecoration(
                            //                     color: Colors.grey.shade300,
                            //                     borderRadius:
                            //                         BorderRadius.circular(10)),
                            //                 child: Center(
                            //                     child: Text(
                            //                         mm?.toString() ?? "mm")),
                            //               ),
                            //             ),
                            //             Container(
                            //               width: 80,
                            //               height: 45,
                            //               decoration: BoxDecoration(
                            //                   color: Colors.grey.shade300,
                            //                   borderRadius:
                            //                       BorderRadius.circular(10)),
                            //               child: Center(
                            //                   child: Text(
                            //                       yyyy?.toString() ?? "yyyy")),
                            //             ),
                            //           ],
                            //         );
                            //       },
                            //     ),
                            //     IconButton(
                            //         onPressed: () {
                            //           context
                            //               .read<UserProfileBloc>()
                            //               .add(OnCalenderIconClickedEvent(
                            //                 context: context,
                            //               ));
                            //         },
                            //         icon: const Icon(Icons.date_range)),
                            //     const SizedBox(
                            //       width: 10,
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: screenWidth * .5,
                              height: 45,
                              child: BlocListener<UserProfileBloc,
                                  UserProfileState>(
                                listener: (context, state) {
                                  if (state is UserDetailAddedState) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (firstNameController.text.isNotEmpty &&
                                        mobileNumberController
                                            .text.isNotEmpty &&
                                        lastNameController.text.isNotEmpty
                                    // &&
                                        // gender != "select a value" &&
                                        // dd != null &&
                                        // mm != null &&
                                        // yyyy != null
                                    ) {
                                      context.read<UserProfileBloc>().add(
                                          OnAddUserDetailsEvent(
                                              firstName:
                                                  firstNameController.text,
                                              lastName: lastNameController.text,
                                              number:
                                                  mobileNumberController.text,
                                              // gender: gender!,
                                              // day: dd,
                                              // month: mm,
                                              // year: yyyy
                                          ));
                                    } else {
                                      debugPrint(gender);
                                      if (gender != "select a value") {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: const Text(
                                                  "Please select your gender!"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("OK"))
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: const Text(
                                                  "Mandatory fields can't be empty!"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("OK"))
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Text("Add details"),
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                ),
              ),
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text("EDIT PROFILE"),
            ),
            child: StreamBuilder<DocumentSnapshot>(
                stream: firestore,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return Center(
                    //   child: CircularProgressIndicator(),
                    // );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  final DocumentSnapshot<Object?>? snapshotData = snapshot.data;
                  if (snapshotData != null) {
                    final DocumentSnapshot<Object?> data = snapshotData;
                    // final Map<String, dynamic>? dateMap = snapshotData["date"];
                    firstNameController.text = data["first_name"];
                    lastNameController.text = data["last_name"];
                    mobileNumberController.text = data["phone_number"];
                    // gender = data["gender"];
                    // dd = dateMap?["day"];
                    // mm = dateMap?["month"];
                    // yyyy = dateMap?["year"];
                  } else {}

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView(
                      children: [
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 40,
                          child: CupertinoTextField(
                            controller: firstNameController,
                            placeholder: "First Name",
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 40,
                          child: CupertinoTextField(
                            controller: lastNameController,
                            placeholder: "Last Name",
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 40,
                          child: CupertinoTextField(
                            controller: mobileNumberController,
                            placeholder: "Phone number",
                          ),
                        ),
                        const SizedBox(height: 15),
                        // BlocBuilder<UserProfileBloc, UserProfileState>(
                        //   builder: (context, state) {
                        //     String? gender;
                        //
                        //     if (state is GenderSelectedState) {
                        //       gender = state.gender;
                        //     }
                        //
                        //     final List<String> items = [
                        //       'Male',
                        //       'Female',
                        //     ]; // Example items
                        //
                        //     return CupertinoDropdownButton<String>(
                        //       value: gender,
                        //       items: items,
                        //       onChanged: (value) {
                        //         context.read<UserProfileBloc>().add(
                        //               OnSelectGenderEvent(gender: value),
                        //             );
                        //       },
                        //     );
                        //   },
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     const SizedBox(
                        //       width: 0,
                        //     ),
                        //     const Text("DOB:"),
                        //     Text(
                        //       '${dd} / ${mm} / ${yyyy}',
                        //       style: const TextStyle(fontSize: 18),
                        //     ),
                        //     CupertinoButton(
                        //       onPressed: () {
                        //         showCupertinoModalPopup(
                        //           context: context,
                        //           builder: (BuildContext context) {
                        //             return Container(
                        //               height: 200,
                        //               child: CupertinoDatePicker(
                        //                 mode: CupertinoDatePickerMode.date,
                        //                 initialDateTime: dd,
                        //                 onDateTimeChanged: (DateTime newDate) {
                        //                   setState(() {
                        //                     dd = newDate;
                        //                   });
                        //                 },
                        //               ),
                        //             );
                        //           },
                        //         );
                        //       },
                        //       child: const Text(
                        //         'Select Date',
                        //         style: TextStyle(color: CupertinoColors.activeBlue),
                        //       ),
                        //     ),
                        //     const SizedBox(
                        //       width: 10,
                        //     ),
                        //   ],
                        // ),
                        // const Spacer(),
                        // CupertinoButton.filled(
                        //   child: const Text("Add"),
                        //   onPressed: () {
                        //     if (firstNameController.text.isNotEmpty &&
                        //         mobileNumberController.text.isNotEmpty &&
                        //         lastNameController.text.isNotEmpty &&
                        //         selectedDate.day != null &&
                        //         selectedDate.month != null &&
                        //         selectedDate.year != null) {
                        //       context.read<UserProfileBloc>().add(
                        //           OnAddUserDetailsEvent(
                        //               firstName: firstNameController.text,
                        //               lastName: lastNameController.text,
                        //               number: mobileNumberController.text,
                        //               gender: gender!,
                        //               day: selectedDate.day,
                        //               month: selectedDate.month,
                        //               year: selectedDate.year));
                        //     } else {
                        //       showCupertinoDialog(
                        //         context: context,
                        //         builder: (context) {
                        //           return CupertinoAlertDialog(
                        //             title: Text("Please add your details properly"),
                        //             actions: [
                        //               CupertinoDialogAction(
                        //                   onPressed: () {
                        //                     Navigator.pop(context);
                        //                   },
                        //                   child: Text("OK"))
                        //             ],
                        //           );
                        //         },
                        //       );
                        //     }
                        //   },
                        // )
                        CupertinoButton(child: const Text("Update"), onPressed: (){
                          if (firstNameController.text.isNotEmpty &&
                              mobileNumberController
                                  .text.isNotEmpty &&
                              lastNameController.text.isNotEmpty
                          // &&
                          // gender != "select a value" &&
                          // dd != null &&
                          // mm != null &&
                          // yyyy != null
                          ) {
                            context.read<UserProfileBloc>().add(
                                OnAddUserDetailsEvent(
                                  firstName:
                                  firstNameController.text,
                                  lastName: lastNameController.text,
                                  number:
                                  mobileNumberController.text,
                                  // gender: gender!,
                                  // day: dd,
                                  // month: mm,
                                  // year: yyyy
                                ));
                          }
                        })
                      ],
                    ),
                  );
                }));
  }

  SizedBox buildSizedBox() => const SizedBox(height: 15);
}
