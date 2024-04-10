import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/address_bloc/address_bloc.dart';
import 'address_repository.dart';

// =================================== Add New Address =========================
Widget addNewAddress({
  required BuildContext context,
  required double screenHeight,
  required double screenWidth,
  required TextEditingController houseNameController,
  required TextEditingController landmarkController,
  required TextEditingController cityController,
  required TextEditingController pincodeController,
}) {
  final address = AddressRepository();
  return AlertDialog(
    title: Text('Add New Address'),
    contentPadding: EdgeInsets.all(16),
    content: Container(
      height: screenHeight * .35,
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildTextField(houseNameController, 'House name/ house no.'),
            SizedBox(height: 10),
            buildTextField(landmarkController, 'Landmark'),
            SizedBox(height: 10),
            buildTextField(cityController, 'City'),
            SizedBox(height: 10),
            buildTextField(pincodeController, 'Pin code'),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          if (validateInputs([
            houseNameController,
            landmarkController,
            cityController,
            pincodeController
          ], context)) {
            context.read<AddressBloc>().add(
                  OnAddAddressEvent(
                    houseName: houseNameController.text,
                    landMark: landmarkController.text,
                    city: cityController.text,
                    pincode: pincodeController.text,
                  ),
                );

            address.fetchAddressFromFirestore();
            Navigator.pop(context);
          }
        },
        child: Text('Add'),
      ),
    ],
  );
}

bool validateInputs(List<TextEditingController> controllers,
    [BuildContext? context]) {
  for (var controller in controllers) {
    if (controller.text.isEmpty) {
      if (context != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please fill in all fields.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
      return false;
    }
  }
  return true;
}

Widget buildTextField(TextEditingController controller, String hintText) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      hintText: hintText,
      labelText: hintText,
    ),
  );
}

// =================================== Edit Address ============================

Future editAddress({
  required BuildContext context,
  required double screenHeight,
  required double screenWidth,
  required String itemId,
  required String userId,
}) async {
  try {
    DocumentSnapshot userAddress = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('address')
        .doc(itemId)
        .get();

    TextEditingController houseNameController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController landMarkController = TextEditingController();
    TextEditingController pincodeController = TextEditingController();

    houseNameController.text = userAddress['houseName'];
    cityController.text = userAddress['city'];
    landMarkController.text = userAddress['landmark'];
    pincodeController.text = userAddress['pincode'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Address"),
          content: Container(
            height: screenHeight * .35,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildTextFieldForEditting(
                    controller: houseNameController,
                    hintText: 'House Name',
                  ),
                  SizedBox(height: 10),
                  buildTextFieldForEditting(
                    controller: cityController,
                    hintText: 'City',
                  ),
                  SizedBox(height: 10),
                  buildTextFieldForEditting(
                    controller: landMarkController,
                    hintText: 'Land Mark',
                  ),
                  SizedBox(height: 10),
                  buildTextFieldForEditting(
                    controller: pincodeController,
                    hintText: 'Pincode',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (isTextFieldValidate([
                  houseNameController,
                  cityController,
                  landMarkController,
                  pincodeController,
                ])) {
                  debugPrint('reached here');
                  context.read<AddressBloc>().add(
                    OnEditAddressEvent(
                      addressId: itemId,
                      houseName: houseNameController.text,
                      landMark: landMarkController.text,
                      city: cityController.text,
                      pincode: pincodeController.text,
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  } catch (error) {
    // Handle errors during asynchronous operation
    print('Error: $error');
  }
}


bool isTextFieldValidate(List<TextEditingController> controllersList,
    [BuildContext? context]) {
  for (var controller in controllersList) {
    if (controller.text.isEmpty) {
      if (context != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please fill in all fields.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
      return false;
    }
  }
  return true;
}

Widget buildTextFieldForEditting(
    {required TextEditingController controller, required String hintText}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      hintText: hintText,
      labelText: hintText,
    ),
  );
}
