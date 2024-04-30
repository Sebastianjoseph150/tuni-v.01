import 'package:flutter/material.dart';
import 'package:tuni/screens/category/pages/cart2.dart';
import 'package:tuni/screens/category/pages/cat1.dart';
import 'package:tuni/screens/category/pages/cat3.dart';
import 'package:tuni/screens/category/pages/cat4.dart';

class CAt extends StatefulWidget {
  const CAt({super.key});

  @override
  _CAtState createState() => _CAtState();
}

class _CAtState extends State<CAt> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('men'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth, // Use full width
            color: Colors.black,
            child: Row(
              children: [
                Container(
                  width: constraints.maxWidth * 0.2, // 20% of screen width
                  color: const Color.fromARGB(255, 204, 203, 201),
                  child: Column(
                    children: [
                      _buildCircleAvatarWithName(Icons.person, "T-shirt", 0),
                      _buildCircleAvatarWithName(Icons.person, "Jeans", 1),
                      _buildCircleAvatarWithName(Icons.person, "shirt", 2),
                      _buildCircleAvatarWithName(Icons.person, "hoodie", 3),
                    ],
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.8,
                  height: double.infinity,
                  child: Center(child: _getscreenForIndex(_selectedIndex)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircleAvatarWithName(
    IconData icon,
    String name,
    int index,
  ) {
    bool isSelected = index == _selectedIndex;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  'https://assets.ajio.com/medias/sys_master/root/20230615/Xs7z/648b116042f9e729d74492c4/-473Wx593H-466278337-white-MODEL.jpg'),
              // child: Icon(icon),
              // backgroundColor: isSelected
              //     ? Colors.grey
              //     : Colors
              //         .transparent,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: TextStyle(
                color: isSelected
                    ? Colors.grey
                    : Colors.black,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getscreenForIndex(int index) {
    // Define colors based on index here
    switch (index) {
      case 0:
        return const Cat1();
      case 1:
        return const Cat2();
      case 2:
        return const Cat3();
      case 3:
        return const Cat4();
      default:
        return const Cat4();
    }
  }
}
