// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuni/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:tuni/bloc/home_bloc/size_bloc.dart';

import '../../../../../bloc/home_bloc/home_bloc.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;
  final String productName;
  final List imageUrl;
  final String brand;
  final String price;
  final String color;
  final List size;
  final String category;
  final String gender;
  final String time;

  late String sizeSelected;
  late int itemCount;

  ProductDetailPage(
      {super.key,
      required this.productId,
      required this.productName,
      required this.imageUrl,
      required this.color,
      required this.brand,
      required this.price,
      required this.size,
      required this.category,
      required this.gender,
      required this.time})
      : sizeSelected = "",
        itemCount = 1;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    context
        .read<SizeBloc>()
        .add(OnChooseSizeEvent(index: -1, selectedSize: ''));
    context
        .read<FavoriteBloc>()
        .add(CheckIsFavorite(productId: widget.productId));
    widget.itemCount = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Platform.isAndroid
        ? Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: screenHeight,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ========================================================= Product image Carousel Slide

                          CarouselSlider(
                              items: widget.imageUrl.map((url) {
                                return Builder(
                                  builder: (context) {
                                    return SizedBox(
                                      height: screenHeight,
                                      width: screenWidth,
                                      child: Image.network(
                                        url,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                              options: CarouselOptions(
                                  height: screenHeight * .5,
                                  viewportFraction: 1)),
                          // ========================================================= Product Name
                          SizedBox(height: screenHeight * .01),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.productName.toUpperCase(),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                                ),
                                Text(
                                  '₹${widget.price}/-',
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1),
                                ),
                              ],
                            ),
                          ),
                          // ========================================================= Brand Name
                          SizedBox(height: screenHeight * .01),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              widget.brand.toUpperCase(),
                              style: const TextStyle(
                                  letterSpacing: 1, fontSize: 20),
                            ),
                          ),
                          // ========================================================= Product Color
                          SizedBox(height: screenHeight * .02),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: RichText(
                                text: TextSpan(
                                    text: 'COLOR: ',
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                  TextSpan(
                                    text: widget.color.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ])),
                          ),
                          // ========================================================= SelectedSize
                          SizedBox(height: screenHeight * .02),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: BlocBuilder<SizeBloc, SizeState>(
                              builder: (context, state) {
                                widget.sizeSelected = state is SizeSelectedState
                                    ? state.selectedSize
                                    : '';
                                return Text('SIZE: ${widget.sizeSelected} ');
                              },
                            ),
                          ),

                          // ========================================================= Size Selection
                          SizedBox(height: screenHeight * .007),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              // color: Colors.grey,
                              height: screenHeight * .05,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.size.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 17),
                                    child: InkWell(
                                      onTap: () {
                                        context.read<SizeBloc>().add(
                                            OnChooseSizeEvent(
                                                index: index,
                                                selectedSize:
                                                    widget.size[index]));
                                      },
                                      child: BlocBuilder<SizeBloc, SizeState>(
                                        builder: (context, state) {
                                          int selectedIndex =
                                              state is SizeSelectedState
                                                  ? state.selectedIndex
                                                  : -1;
                                          return Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                    color:
                                                        selectedIndex == index
                                                            ? Colors.black
                                                            : Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Text(
                                                widget.size[index],
                                                style: TextStyle(
                                                    fontSize:
                                                        selectedIndex == index
                                                            ? 20
                                                            : 12,
                                                    color:
                                                        selectedIndex == index
                                                            ? Colors.black
                                                            : Colors.grey),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          //========================================================== Quantity Widget
                          SizedBox(height: screenHeight * .02),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text('QUANTITY: ')),
                          SizedBox(height: screenHeight * .01),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: BlocBuilder<HomeBloc, HomeState>(
                              builder: (context, state) {
                                widget.itemCount = 1;
                                // debugPrint(widget.itemCount.toString());
                                if (state is ItemCountAddedState) {
                                  widget.itemCount = state.itemCount;
                                } else if (state is ItemCountRemovedState) {
                                  widget.itemCount = state.itemCount;
                                }
                                return Container(
                                  width: 180,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.black45)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            context.read<HomeBloc>().add(
                                                OnRemoveCartButtonPressed());
                                          },
                                          icon: const Icon(Icons.remove)),
                                      Text(
                                        widget.itemCount.toString(),
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            context
                                                .read<HomeBloc>()
                                                .add(OnAddCartButtonPressed());
                                          },
                                          icon: const Icon(Icons.add)),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                          left: screenHeight * .01,
                          top: screenHeight * .01,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 30,
                              )))
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              height: 80,
              color: Colors.grey.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BlocConsumer<FavoriteBloc, FavoriteState>(
                    listener: (BuildContext context, FavoriteState state) {},
                    builder: (context, state) {
                      final isFavorite = state is FavoriteChangedState &&
                          state.isFavorite &&
                          state.productId == widget.productId;
                      return Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: IconButton(
                            onPressed: () async {
                              context.read<FavoriteBloc>().add(
                                  ToggleFavoriteEvent(
                                      productId: widget.productId,
                                      name: widget.productName,
                                      price: widget.price,
                                      brand: widget.brand,
                                      imageUrl: widget.imageUrl,
                                      gender: widget.gender,
                                      time: widget.time,
                                      category: widget.category,
                                      color: widget.color,
                                      size: widget.size));
                              const addedToFavorite = "Item added to favorite";
                              const removedFromFavorite =
                                  "Item removed from favorite";

                              isFavorite
                                  ? ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content: Text(removedFromFavorite),
                                      duration: Duration(milliseconds: 500),
                                    ))
                                  : ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content: Text(addedToFavorite),
                                      duration: Duration(milliseconds: 500),
                                    ));
                            },
                            icon: isFavorite
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(Icons.favorite_border),
                          ));
                    },
                  ),
                  SizedBox(
                      width: 250,
                      height: 50,
                      child: BlocListener<HomeBloc, HomeState>(
                        listener: (context, state) {
                          if (state is SizeNotSelectedState) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Please select your size before adding to cart",
                                      style: TextStyle(color: Colors.white),
                                    )));
                          }
                          if (state is AddedToCartSuccessState) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Added to Cart"),
                              duration: Duration(milliseconds: 1500),
                            ));
                          }
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<HomeBloc>().add(
                                OnAddedToCartButtonPressedEvent(
                                    id: widget.productId,
                                    name: widget.productName,
                                    image: widget.imageUrl,
                                    price: widget.price,
                                    color: widget.color,
                                    itemCount: widget.itemCount.toString(),
                                    selectedSize: widget.sizeSelected));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey.shade500,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text('Add to Cart'),
                        ),
                      )),
                ],
              ),
            ),
          )
        : CupertinoPageScaffold(
            child: SafeArea(
            child: CupertinoScrollbar(
              child: SizedBox(
                height: screenHeight,
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ========================================================= Product image Carousel Slide

                            CarouselSlider(
                                items: widget.imageUrl.map((url) {
                                  return Builder(
                                    builder: (context) {
                                      return SizedBox(
                                        height: screenHeight,
                                        width: screenWidth,
                                        child: Image.network(
                                          url,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return const Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              );
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                    height: screenHeight * .5,
                                    viewportFraction: 1)),
                            // ========================================================= Product Name
                            SizedBox(height: screenHeight * .01),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.productName.toUpperCase(),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    ),
                                  ),
                                  Text(
                                    '₹${widget.price}/-',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                                ],
                              ),
                            ),
                            // ========================================================= Brand Name
                            SizedBox(height: screenHeight * .01),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                widget.brand.toUpperCase(),
                                style: const TextStyle(
                                    letterSpacing: 1, fontSize: 20),
                              ),
                            ),
                            // ========================================================= Product Color
                            SizedBox(height: screenHeight * .02),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: RichText(
                                  text: TextSpan(
                                      text: 'COLOR: ',
                                      style: const TextStyle(
                                          color: CupertinoColors.black),
                                      children: [
                                    TextSpan(
                                      text: widget.color.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: CupertinoColors.black),
                                    ),
                                  ])),
                            ),
                            // ========================================================= SelectedSize
                            SizedBox(height: screenHeight * .02),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: BlocBuilder<SizeBloc, SizeState>(
                                builder: (context, state) {
                                  widget.sizeSelected =
                                      state is SizeSelectedState
                                          ? state.selectedSize
                                          : '';
                                  return Text('SIZE: ${widget.sizeSelected} ');
                                },
                              ),
                            ),

                            // ========================================================= Size Selection
                            SizedBox(height: screenHeight * .007),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                // color: Colors.grey,
                                height: screenHeight * .035,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.size.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 17),
                                      child: GestureDetector(
                                        onTap: () {
                                          context.read<SizeBloc>().add(
                                              OnChooseSizeEvent(
                                                  index: index,
                                                  selectedSize:
                                                      widget.size[index]));
                                        },
                                        child: BlocBuilder<SizeBloc, SizeState>(
                                          builder: (context, state) {
                                            int selectedIndex =
                                                state is SizeSelectedState
                                                    ? state.selectedIndex
                                                    : -1;
                                            return Container(
                                              // height: 30,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                // shape: BoxShape.circle,
                                                // borderRadius:
                                                //     BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: selectedIndex == index
                                                      ? CupertinoColors.black
                                                      : CupertinoColors
                                                          .systemGrey,
                                                ),
                                                color: CupertinoColors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  widget.size[index],
                                                  style: TextStyle(
                                                    fontSize:
                                                        selectedIndex == index
                                                            ? 22
                                                            : 15,
                                                    color: selectedIndex ==
                                                            index
                                                        ? CupertinoColors.black
                                                        : CupertinoColors
                                                            .systemGrey,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            //========================================================== Quantity Widget
                            SizedBox(height: screenHeight * .02),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text('QUANTITY: ')),
                            SizedBox(height: screenHeight * .01),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: BlocBuilder<HomeBloc, HomeState>(
                                builder: (context, state) {
                                  widget.itemCount = 1;
                                  // debugPrint(widget.itemCount.toString());
                                  if (state is ItemCountAddedState) {
                                    widget.itemCount = state.itemCount;
                                  } else if (state is ItemCountRemovedState) {
                                    widget.itemCount = state.itemCount;
                                  }
                                  return Container(
                                    width: 180,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: CupertinoColors.black)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            context.read<HomeBloc>().add(
                                                OnRemoveCartButtonPressed());
                                          },
                                          child:
                                              const Icon(CupertinoIcons.minus),
                                        ),
                                        Text(
                                          widget.itemCount.toString(),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            context
                                                .read<HomeBloc>()
                                                .add(OnAddCartButtonPressed());
                                          },
                                          child: const Icon(CupertinoIcons.add),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 5),

                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              // Adjust margin as needed
                              height: 1.0,
                              // Height of the divider
                              color: CupertinoColors
                                  .systemGrey4, // Color of the divider
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                BlocConsumer<FavoriteBloc, FavoriteState>(
                                  listener: (BuildContext context,
                                      FavoriteState state) {},
                                  builder: (context, state) {
                                    final isFavorite =
                                        state is FavoriteChangedState &&
                                            state.isFavorite &&
                                            state.productId == widget.productId;
                                    return Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                            color: CupertinoColors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: CupertinoButton(
                                          onPressed: () async {
                                            context.read<FavoriteBloc>().add(
                                                ToggleFavoriteEvent(
                                                    productId: widget.productId,
                                                    name: widget.productName,
                                                    price: widget.price,
                                                    brand: widget.brand,
                                                    imageUrl: widget.imageUrl,
                                                    gender: widget.gender,
                                                    time: widget.time,
                                                    category: widget.category,
                                                    color: widget.color,
                                                    size: widget.size));
                                            const addedToFavorite =
                                                "Item added to favorite";
                                            const removedFromFavorite =
                                                "Item removed from favorite";

                                            showCupertinoModalPopup(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CupertinoActionSheet(
                                                  message: isFavorite
                                                      ? const Text(
                                                          removedFromFavorite)
                                                      : const Text(
                                                          addedToFavorite),
                                                  actions: [
                                                    CupertinoActionSheetAction(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            Future.delayed(const Duration(seconds: 2),
                                                () {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: isFavorite
                                              ? const Icon(
                                                  CupertinoIcons.heart_fill,
                                                  color:
                                                      CupertinoColors.systemRed,
                                                )
                                              : const Icon(
                                                  CupertinoIcons.heart),
                                        ));
                                  },
                                ),
                                SizedBox(
                                    width: 250,
                                    height: 50,
                                    child: BlocListener<HomeBloc, HomeState>(
                                      listener: (context, state) {
                                        if (state is SizeNotSelectedState) {
                                          showTemporaryMessage(
                                              context: context,
                                              message:
                                                  "Please select your size before adding to cart");
                                        }

                                        if (state is AddedToCartSuccessState) {
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CupertinoActionSheet(
                                                message:
                                                    const Text("Added to Cart"),
                                                actions: [
                                                  CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: CupertinoButton.filled(
                                        onPressed: () {
                                          context.read<HomeBloc>().add(
                                              OnAddedToCartButtonPressedEvent(
                                                  id: widget.productId,
                                                  name: widget.productName,
                                                  image: widget.imageUrl,
                                                  price: widget.price,
                                                  color: widget.color,
                                                  itemCount: widget.itemCount
                                                      .toString(),
                                                  selectedSize:
                                                      widget.sizeSelected));
                                        },
                                        // style: ElevatedButton.styleFrom(
                                        //     backgroundColor:
                                        //         Colors.blueGrey.shade500,
                                        //     shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10))),
                                        child: const Text('Add to Cart'),
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                        Positioned(
                            left: screenHeight * .01,
                            top: screenHeight * .01,
                            child: CupertinoButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  CupertinoIcons.back,
                                  size: 30,
                                )))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
  }

  void showTemporaryMessage(
      {required BuildContext context,
      required String message,
      Duration duration = const Duration(seconds: 2)}) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          message: Text(
            message,
            style: const TextStyle(fontSize: 20, color: CupertinoColors.black),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    Future.delayed(duration, () {
      Navigator.pop(context);
    });
  }
}
