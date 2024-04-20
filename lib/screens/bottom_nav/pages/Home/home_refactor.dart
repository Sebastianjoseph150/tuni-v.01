import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuni/bloc/favorite_bloc/favorite_repository.dart';
import 'package:tuni/screens/bottom_nav/pages/Home/pages_in_home_page/category_product_list.dart';
import 'package:tuni/screens/bottom_nav/pages/Home/pages_in_home_page/product_detail_page.dart';
import 'package:tuni/screens/search/search_widget.dart';

import '../../../../bloc/favorite_bloc/favorite_bloc.dart';
import '../caterory/pages_in_categories/category_all_page.dart';
import '../caterory/pages_in_categories/category_kids_page.dart';
import '../caterory/pages_in_categories/category_men_page.dart';
import '../caterory/pages_in_categories/category_women_page.dart';

class MainPageSliverAppBar extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  MainPageSliverAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      foregroundColor: Colors.black,
      title: const Text(
        'TUNI',
        style: TextStyle(
            letterSpacing: 8, fontSize: 30, fontWeight: FontWeight.w500),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
              // SearchBar(
              //   controller: _searchController,
              //   onChanged: (value) {
              //     // Perform search operation based on the value
              //   },
              // );
            },
            icon: const Icon(
              Icons.search,
              size: 35,
            ))
      ],
      floating: true,
      snap: true,
      toolbarHeight: 80,
    );
  }
}

class MainPageFilterByCategory extends StatelessWidget {
  const MainPageFilterByCategory({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: screenWidth,
        height: screenHeight * .42,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllCategory(),
                        ));
                  },
                  child: mainPageCircularAvatar(
                      screenWidth: screenWidth, name: 'ALL'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenCategory(),
                        ));
                  },
                  child: mainPageCircularAvatar(
                      screenWidth: screenWidth, name: 'MEN'),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WomenCategory(),
                        ));
                  },
                  child: mainPageCircularAvatar(
                      screenWidth: screenWidth, name: 'WOMEN'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KidsCategory(),
                        ));
                  },
                  child: mainPageCircularAvatar(
                      screenWidth: screenWidth, name: 'KIDS'),
                )
              ],
            ),
          ],
        ));
  }
}

class MainPageSeeMoreTextButton extends StatelessWidget {
  const MainPageSeeMoreTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllCategory(),
              ));
        },
        child: const Text('view all products'));
  }
}

class MainPageGridViewProductList extends StatelessWidget {
  const MainPageGridViewProductList({
    Key? key,
    required this.firestore,
  }) : super(key: key);

  final Stream<QuerySnapshot<Map<String, dynamic>>> firestore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        child: StreamBuilder(
          stream: firestore,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return const Center(
                child: CircularProgressIndicator(),
              );

            List<DocumentSnapshot> products = snapshot.data!.docs;
            products.shuffle();

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: .75, crossAxisCount: 2),
              itemCount: products.length < 4 ? products.length : 4,
              itemBuilder: (context, index) {
                final productId = products[index]["id"];
                final productName = products[index]["name"];
                final productPrice = products[index]["price"];
                final imageUrl = products[index]["imageUrl"][0];
                final imageUrlList = products[index]["imageUrl"];
                final color = products[index]["color"];
                final brand = products[index]["brand"];
                final price = products[index]["price"];
                final gender = products[index]["gender"];
                final category = products[index]["category"];
                final time = products[index]["time"];
                final List size = products[index]["size"];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          productId: productId,
                          productName: productName,
                          imageUrl: imageUrlList,
                          color: color,
                          brand: brand,
                          price: price,
                          size: size,
                          category: category,
                          gender: gender,
                          time: time,
                        ),
                      ),
                    );
                  },
                  child: mainPageView(
                    brand: brand,
                    category: category,
                    gender: gender,
                    time: time,
                    productId: productId,
                    index: index,
                    productName: productName,
                    imageUrl: imageUrl,
                    productPrice: productPrice,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

Widget mainPageHeading(String text) {
  return Text(
    text.toUpperCase(),
    style: const TextStyle(fontSize: 20, letterSpacing: 3),
  );
}

Widget mainPageCircularAvatar({
  required double screenWidth,
  required String name,
}) {
  return CircleAvatar(
    radius: screenWidth * .15,
    backgroundColor: Colors.grey.shade200,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.blueGrey.shade800),
          ),
        ],
      ),
    ),
  );
}

TextStyle customTextStyle() {
  return const TextStyle(
    letterSpacing: 1,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
}

FavoriteBloc favoriteBloc = FavoriteBloc();
FavoriteRepository favoriteRepository = FavoriteRepository();

Widget mainPageView(
    {required String productName,
    required String productPrice,
    required String imageUrl,
    required int index,
    required String productId,
    required String time,
    required String gender,
    required String category,
    required String brand}) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 170,
              width: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              decoration: BoxDecoration(
                  // color: Colors.amber,
                  borderRadius: BorderRadius.circular(30)),
            ),
          ],
        ),
        Container(
          width: 160,
          height: 60,
          padding: const EdgeInsets.all(10),
          // color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(productName.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: customTextStyle()),
              ),
              Text("₹${productPrice}/-", style: customTextStyle())
            ],
          ),
        ),
      ],
    ),
  );
}

class MainPageCarouselSlider extends StatelessWidget {
  const MainPageCarouselSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        items: [
          {'imagePath': 'Assets/Images/BAnner_grande.webp', 'text': 'T-shirts'},
          {'imagePath': 'Assets/Images/images.jpg', 'text': 'Shirts'},
          {'imagePath': 'Assets/Images/BAnner_grande.webp', 'text': 'T-shirts'},
        ].map((item) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: InkWell(
                  onTap: () {
                    // Handle onTap action here
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Image.asset(
                          item['imagePath']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              item['text']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 33,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
          autoPlay: true, // Enable auto play
          // Add other options here
        ),
      ),
    );
  }
}
