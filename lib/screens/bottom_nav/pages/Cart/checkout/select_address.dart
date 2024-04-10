import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tuni/screens/bottom_nav/pages/Cart/checkout/checkout_page.dart';

import '../../../../../model/product_order_model.dart';
import '../../../../drawer/pages_in_drawer/shipping_address/address_refactor.dart';

class SelectAddress extends StatelessWidget {
  final List<OrderModel> orderList;
  final int total;

  SelectAddress({
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
    final TextEditingController CityController = TextEditingController();
    final TextEditingController pinCodeController = TextEditingController();
    return Scaffold(
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
                            cityController: CityController,
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
                    print('Error: ${snapshot.error}');
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
                          startActionPane:
                              ActionPane(motion: const StretchMotion(), children: [
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
                                      content:
                                          Text('Address Selected $address')));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(style: BorderStyle.none),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            text: snapshot
                                                .data!.docs[index]['landmark']
                                                .toString(),
                                          )
                                        ])),
                                    const SizedBox(height: 5),
                                    Text(snapshot.data!.docs[index]['pincode']
                                        .toString()),
                                    const SizedBox(height: 5),
                                  ],
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
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
                height: 45,
                child: ElevatedButton(
                    onPressed: () {
                      if (address.isNotEmpty) {
                        // debugPrint(idList.toString());
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
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                          'Select an address',
                          style: TextStyle(color: Colors.red),
                        )));
                      }
                    },
                    child: const Text("PAY"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))))),
          ),
          color: Colors.white,
        ));
  }
}
