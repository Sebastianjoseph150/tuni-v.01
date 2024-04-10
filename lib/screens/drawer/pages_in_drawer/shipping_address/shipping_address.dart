import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tuni/screens/drawer/pages_in_drawer/shipping_address/address_refactor.dart';

class ShippingAddress extends StatelessWidget {
  ShippingAddress({Key? key}) : super(key: key);

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
    final TextEditingController CityController = TextEditingController();
    final TextEditingController pinCodeController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text(
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
                            cityController: CityController,
                            pincodeController: pinCodeController);
                      });
                },
                child: Text('New Address'))
          ],
        ),
        backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Center(child: Text('Some error occurred'));
                    }
                    if (snapshot.data!.docs.isEmpty || !snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          height: screenHeight * .52,
                          child: Column(
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
                          startActionPane:
                              ActionPane(motion: StretchMotion(), children: [
                            SlidableAction(
                              onPressed: (_) async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text("Delete this Address?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("No")),
                                        TextButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(userId)
                                                  .collection('address')
                                                  .doc(addressId)
                                                  .delete();
                                              Navigator.pop(context);

                                            },
                                            child: Text("Yes")),
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
                                Widget dialogContent = await editAddress(
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
                                side: BorderSide(style: BorderStyle.none),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadowColor: Colors.white,
                              child: ListTile(
                                leading: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                title: Text(
                                  snapshot.data!.docs[index]['houseName']
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    RichText(
                                        text: TextSpan(
                                            text: snapshot
                                                .data!.docs[index]['city']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: 1),
                                            children: [
                                          TextSpan(
                                            text: ', ',
                                          ),
                                          TextSpan(
                                            text: snapshot
                                                .data!.docs[index]['landmark']
                                                .toString(),
                                          )
                                        ])),
                                    SizedBox(height: 5),
                                    Text(snapshot.data!.docs[index]['pincode']
                                        .toString()),
                                    SizedBox(height: 5),
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
        ));
  }
}
