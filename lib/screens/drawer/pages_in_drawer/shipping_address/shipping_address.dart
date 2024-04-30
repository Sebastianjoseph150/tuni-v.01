import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tuni/screens/drawer/pages_in_drawer/shipping_address/address_refactor.dart';

class ShippingAddress extends StatelessWidget {
  const ShippingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    String userId = user!.uid;
    final firestore = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('address')
        .snapshots();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final TextEditingController houseNameController = TextEditingController();
    final TextEditingController landMarkController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController pinCodeController = TextEditingController();

    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              title: const Text(
                'ADDRESS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return addNewAddress(
                                context: context,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                houseNameController: houseNameController,
                                landmarkController: landMarkController,
                                cityController: cityController,
                                pincodeController: pinCodeController);
                          });
                    },
                    child: const Text('New Address'))
              ],
            ),
            backgroundColor: Colors.grey.shade200,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: firestore,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Some error occurred'));
                        }
                        if (snapshot.data!.docs.isEmpty || !snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              height: screenHeight * .52,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("You have no address added!")],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            String addressId = snapshot.data!.docs[index].id;
                            return Slidable(
                              startActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: const Text(
                                                  "Delete this Address?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("No")),
                                                TextButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(userId)
                                                          .collection('address')
                                                          .doc(addressId)
                                                          .delete();
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Yes")),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: Icons.delete,
                                      label: 'delete',
                                    ),
                                    SlidableAction(
                                      onPressed: (_) async {
                                        Widget dialogContent =
                                            await editAddress(
                                                screenHeight: screenHeight,
                                                screenWidth: screenWidth,
                                                context: context,
                                                itemId: addressId,
                                                userId: userId);
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return dialogContent;
                                          },
                                        );
                                      },
                                      icon: Icons.edit,
                                      label: 'edit',
                                    ),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        style: BorderStyle.none),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadowColor: Colors.white,
                                  child: ListTile(
                                    leading: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    title: Text(
                                      snapshot.data!.docs[index]['houseName']
                                          .toString()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5),
                                        RichText(
                                            text: TextSpan(
                                                text: snapshot
                                                    .data!.docs[index]['city']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    letterSpacing: 1),
                                                children: [
                                              const TextSpan(
                                                text: ', ',
                                              ),
                                              TextSpan(
                                                text: snapshot.data!
                                                    .docs[index]['landmark']
                                                    .toString(),
                                              )
                                            ])),
                                        const SizedBox(height: 5),
                                        Text(snapshot
                                            .data!.docs[index]['pincode']
                                            .toString()),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ))
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("ADDRESS"),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return addNewAddressIos(
                        context: context,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        houseNameController: houseNameController,
                        landmarkController: landMarkController,
                        cityController: cityController,
                        pincodeController: pinCodeController,
                      );
                    },
                  );
                },
                child: const Icon(
                  CupertinoIcons.add,
                  size: 25,
                ),
              ),
            ),
            child: SizedBox(
              height: screenHeight,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: firestore,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CupertinoActivityIndicator());
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Some error occurred'));
                              }
                              if (snapshot.data!.docs.isEmpty ||
                                  !snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    height: screenHeight * .52,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("You have no address added!")
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.docs.length ?? 0,
                                itemBuilder: (context, index) {
                                  String addressId =
                                      snapshot.data!.docs[index].id;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Slidable(
                                      startActionPane: ActionPane(
                                          motion: const StretchMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (_) async {
                                                showCupertinoDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CupertinoAlertDialog(
                                                      content: const Text(
                                                          "Delete this Address?"),
                                                      actions: [
                                                        CupertinoDialogAction(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "No")),
                                                        CupertinoDialogAction(
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(userId)
                                                                  .collection(
                                                                      'address')
                                                                  .doc(
                                                                      addressId)
                                                                  .delete();
                                                            },
                                                            child: const Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                  color: CupertinoColors
                                                                      .systemRed),
                                                            )),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: CupertinoIcons.delete,
                                              label: 'delete',
                                            ),
                                            SlidableAction(
                                              onPressed: (_) async {
                                                Widget dialogContent =
                                                    await editAddress(
                                                        screenHeight:
                                                            screenHeight,
                                                        screenWidth:
                                                            screenWidth,
                                                        context: context,
                                                        itemId: addressId,
                                                        userId: userId);
                                                showCupertinoDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return dialogContent;
                                                  },
                                                );
                                              },
                                              icon: CupertinoIcons.pen,
                                              label: 'edit',
                                            ),
                                          ]),
                                      child: CupertinoListTile(
                                          leading: Text("${index + 1}"),
                                          title: Text(
                                            snapshot
                                                .data!.docs[index]['houseName']
                                                .toString()
                                                .toUpperCase(),
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                          subtitle: Text(
                                            snapshot.data!.docs[index]['city']
                                                .toString()
                                                .toUpperCase(),
                                            style: const TextStyle(fontSize: 15),
                                          ),
                                          additionalInfo: const Icon(
                                            CupertinoIcons.info,
                                            size: 15,
                                          )),
                                    ),
                                  );
                                },
                              );
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
