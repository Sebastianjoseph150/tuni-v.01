import 'package:flutter/material.dart';
import 'package:tuni/screens/category/pages/cart2.dart';
import 'package:tuni/screens/category/pages/cat1.dart';
import 'package:tuni/screens/category/pages/cat3.dart';
import 'package:tuni/screens/category/pages/cat4.dart';

class CAt extends StatefulWidget {
  const CAt({Key? key});

  @override
  _CAtState createState() => _CAtState();
}

class _CAtState extends State<CAt> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('men'),
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
                  color: Color.fromARGB(255, 204, 203, 201),
                  child: Column(
                    children: [
                      _buildCircleAvatarWithName(Icons.person, "T-shirt", 0),
                      _buildCircleAvatarWithName(Icons.person, "Jeans", 1),
                      _buildCircleAvatarWithName(Icons.person, "shirt", 2),
                      _buildCircleAvatarWithName(Icons.person, "hoodie", 3),
                    ],
                  ),
                ),
                Container(
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
      padding: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index; // Update selected index
          });
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  'https://assets.ajio.com/medias/sys_master/root/20230615/Xs7z/648b116042f9e729d74492c4/-473Wx593H-466278337-white-MODEL.jpg'),
              // child: Icon(icon),
              // backgroundColor: isSelected
              //     ? Colors.grey
              //     : Colors
              //         .transparent, // Set background color based on selection
            ),
            SizedBox(
              height: 5,
            ), // Add some spacing between the icon and the name
            Text(
              name,
              style: TextStyle(
                color: isSelected
                    ? Colors.grey
                    : Colors.black, // Set text color based on selection
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal, // Make text bold for selected item
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
        return Cat1();
      case 1:
        return Cat2();
      case 2:
        return Cat3();
      case 3:
        return cat4();
      default:
        return cat4(); // Default color
    }
  }
}
