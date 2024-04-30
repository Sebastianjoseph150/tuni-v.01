import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tuni/screens/bottom_nav/pages/Cart/checkout/checkout_page.dart';

import '../../../../../model/product_order_model.dart';
import '../../../../drawer/pages_in_drawer/shipping_address/address_refactor.dart';

class SelectAddress extends StatelessWidget {
  final List<OrderModel> orderList;
  final int total;

  const SelectAddress({
    super.key,
    required this.orderList,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    String userId = user!.uid;
    final firestore = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('address')
        .snapshots();

    Map<String, dynamic> address = {};

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
                'Your Address',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
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
            body: Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestore,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Some error occurred'));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          String addressId = snapshot.data!.docs[index].id;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Slidable(
                              startActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) async {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(userId)
                                            .collection('address')
                                            .doc(addressId)
                                            .delete();
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
                              child: InkWell(
                                onTap: () {
                                  address = {
                                    "houseName": snapshot.data!.docs[index]
                                        ['houseName'],
                                    "city": snapshot.data!.docs[index]['city'],
                                    "landmark": snapshot.data!.docs[index]
                                        ['landmark'],
                                    "pincode": snapshot.data!.docs[index]
                                        ['pincode'],
                                  };

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Address Selected $address')));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        style: BorderStyle.none),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadowColor: Colors.white,
                                  child:
                                      //  ListTile(
                                      //   leading: Text(
                                      //     '${index + 1}',
                                      //     style: const TextStyle(
                                      //         fontSize: 18,
                                      //         fontWeight: FontWeight.w400),
                                      //   ),
                                      //   title: Text(
                                      //     snapshot.data!.docs[index]['houseName']
                                      //         .toString()
                                      //         .toUpperCase(),
                                      //     style: const TextStyle(
                                      //         color: Colors.black,
                                      //         fontSize: 18,
                                      //         fontWeight: FontWeight.bold,
                                      //         letterSpacing: 1.5),
                                      //   ),
                                      //   subtitle: Column(
                                      //     crossAxisAlignment: CrossAxisAlignment.start,
                                      //     children: [
                                      //       const SizedBox(height: 5),
                                      //       RichText(
                                      //           text: TextSpan(
                                      //               text: snapshot
                                      //                   .data!.docs[index]['city']
                                      //                   .toString()
                                      //                   .toUpperCase(),
                                      //               style: const TextStyle(
                                      //                   color: Colors.black,
                                      //                   letterSpacing: 1),
                                      //               children: [
                                      //             const TextSpan(
                                      //               text: ', ',
                                      //             ),
                                      //             TextSpan(
                                      //               text: snapshot
                                      //                   .data!.docs[index]['landmark']
                                      //                   .toString(),
                                      //             )
                                      //           ])),
                                      //       const SizedBox(height: 5),
                                      //       Text(snapshot.data!.docs[index]['pincode']
                                      //           .toString()),
                                      //       const SizedBox(height: 5),
                                      //     ],
                                      //   ),
                                      // ),
                                      ListTile(
                                    leading: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    title: Text(
                                      snapshot.data!.docs[index]['houseName']
                                          .toString()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
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
                                              letterSpacing: 1,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: ', ',
                                              ),
                                              TextSpan(
                                                text: snapshot.data!
                                                    .docs[index]['landmark']
                                                    .toString(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(snapshot
                                            .data!.docs[index]['pincode']
                                            .toString()),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Delete Address'),
                                              content: const Text(
                                                  'Are you sure you want to delete this address?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(userId)
                                                        .collection('address')
                                                        .doc(addressId)
                                                        .delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
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
            bottomNavigationBar: BottomAppBar(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () {
                          if (address.isNotEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckOutFromCartPage(
                                    address: address,
                                    orderList: orderList,
                                    total: total,
                                  ),
                                ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Text(
                              'Select an address',
                              style: TextStyle(color: Colors.red),
                            )));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: const Text("PAY"))),
              ),
            ))
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("SELECT ADDRESS"),
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
                    child: StreamBuilder(
                      stream: firestore,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Some error occurred'));
                        }
                        return CupertinoScrollbar(
                          child: ListView.builder(
                            itemCount: snapshot.data?.docs.length ?? 0,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  address = {
                                    "houseName": snapshot.data!.docs[index]
                                        ['houseName'],
                                    "city": snapshot.data!.docs[index]['city'],
                                    "landmark": snapshot.data!.docs[index]
                                        ['landmark'],
                                    "pincode": snapshot.data!.docs[index]
                                        ['pincode'],
                                  };

                                  String houseName = address["houseName"];
                                  String city = address["city"];
                                  String landmark = address["landmark"];
                                  String pincode = address["pincode"];

                                  showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text(
                                          'Selected Address',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: CupertinoColors.black),
                                        ),
                                        content: Column(
                                          children: [
                                            const SizedBox(height: 20),
                                            _buildAddressRow(
                                                "House Name: ", houseName),
                                            _buildAddressRow("City: ", city),
                                            _buildAddressRow(
                                                "Landmark: ", landmark),
                                            _buildAddressRow(
                                                "Pincode: ", pincode),
                                          ],
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the modal sheet
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          CupertinoDialogAction(
                                            onPressed: () {
                                              if (address.isNotEmpty) {
                                                Navigator.pop(context);

                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          CheckOutFromCartPage(
                                                        address: address,
                                                        orderList: orderList,
                                                        total: total,
                                                      ),
                                                    ));
                                              }
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: SizedBox(
                                  child: CupertinoListTile(
                                      title: Text(snapshot
                                          .data!.docs[index]['houseName']
                                          .toString()
                                          .toUpperCase()),
                                      subtitle: Text(snapshot
                                          .data!.docs[index]['city']
                                          .toString()
                                          .toUpperCase()),
                                      additionalInfo: const Icon(
                                        CupertinoIcons.right_chevron,
                                        size: 20,
                                      )),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  TextStyle styles() {
    return const TextStyle(color: CupertinoColors.black, fontSize: 15);
  }

  TextStyle addressStyles() {
    return const TextStyle(
        color: CupertinoColors.black,
        fontSize: 17,
        fontWeight: FontWeight.bold);
  }

  Widget _buildAddressRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: styles(),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: addressStyles(),
          ),
        ),
      ],
    );
  }
}
