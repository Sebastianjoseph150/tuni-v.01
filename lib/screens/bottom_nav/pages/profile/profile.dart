
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuni/screens/bottom_nav/pages/Favorites/favorite_page.dart';
import 'package:tuni/screens/drawer/pages_in_drawer/profile/user_profile.dart';
import 'package:tuni/screens/drawer/pages_in_drawer/shipping_address/shipping_address.dart';
import '../../../../bloc/home_bloc/home_bloc.dart';
import '../../../auth/sign_in/login.dart';
import '../../../drawer/pages_in_drawer/my_orders/user_orders.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final userId = user!.uid;
    final String userEmail = user?.email ?? "";
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("PROFILE"),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: CupertinoListSection(
            backgroundColor: Colors.white,
            children: [
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(userId)
                      .collection("personal_details")
                      .doc(userEmail)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Text(" ");
                    }
                    String name = "";
                    String? initials;

                    if (snapshot.hasData && snapshot.data!.exists) {
                      var data = snapshot.data!.data() as Map<String, dynamic>;
                      name =
                          "${data["first_name"] ?? ""} ${data["last_name"] ?? ""}";
                      String? firstName = data["first_name"];
                      String? lastName = data["last_name"];

                      initials =
                          "${firstName?.isNotEmpty == true ? firstName![0] : ""}${lastName?.isNotEmpty == true ? lastName![0] : ""}";
                    }
                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: screenWidth * .1,
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: initials,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * .07)),
                              // TextSpan(text: ""),
                            ]),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          height: 60,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2),
                                ),
                                Text(
                                  userEmail,
                                  style:
                                      const TextStyle(fontSize: 16, letterSpacing: 1),
                                ),
                              ]),
                        )
                      ],
                    );
                  }),
              const SizedBox(height: 20),
              CupertinoListTile(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => UserProfile()));
                },
                leading: const Icon(
                  CupertinoIcons.person,
                  size: 20,
                ),
                title: const Text("Profile Details"),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  size: 15,
                ),
              ),
              CupertinoListTile(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => UserOrders()));
                },
                leading: const Icon(
                  CupertinoIcons.list_bullet_below_rectangle,
                  size: 20,
                ),
                title: const Text("Order History"),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  size: 15,
                ),
              ),
              CupertinoListTile(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => FavoritePage()));
                },
                leading: const Icon(
                  CupertinoIcons.heart,
                  size: 20,
                ),
                title: const Text("Favorites"),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  size: 15,
                ),
              ),
              CupertinoListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const ShippingAddress(),
                      ));
                },
                leading: const Icon(
                  CupertinoIcons.location_north_line,
                  size: 20,
                ),
                title: const Text("Address Book"),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  size: 15,
                ),
              ),
              CupertinoListTile(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     CupertinoPageRoute(
                  //         builder: (context) => PrivacyPolicyPdfViewer()));
                },
                leading: const Icon(
                  CupertinoIcons.info,
                  size: 20,
                ),
                title: const Text("Privacy Policy"),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  size: 15,
                ),
              ),
              BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is LoggedOutSuccessState) {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text("You'll be missed!"),
                          content: const Text(
                              'Are you sure?  Do you want to Logout?'),
                          actions: [
                            CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No")),
                            CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => LogInPage(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: const Text("Logout")),
                          ],
                        );
                      },
                    );
                  }
                },
                child: CupertinoListTile(
                  onTap: () {
                    context.read<HomeBloc>().add(OnLogoutEvent());
                  },
                  leading: const Icon(
                    Icons.logout,
                    size: 20,
                  ),
                  title: const Text("Logout"),
                  trailing: const Icon(
                    CupertinoIcons.right_chevron,
                    size: 15,
                  ),
                ),
              ),
              CupertinoButton(
                  child: const Text(
                    "Delete Account",
                    style: TextStyle(color: CupertinoColors.systemRed),
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text("Leaving us?"),
                          content: const Text(
                              "Are you sure you want to delete your account?"),
                          actions: [
                            CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No")),
                            CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => LogInPage(),
                                      ),
                                      (route) => false);
                                  context
                                      .read<HomeBloc>()
                                      .add(OnDeleteUserEvent());
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: CupertinoColors.systemRed),
                                )),
                          ],
                        );
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
