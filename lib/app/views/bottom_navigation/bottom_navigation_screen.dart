import 'package:flutter/material.dart';
import 'package:home_automation/app/views/security/security_screen.dart';
import 'package:home_automation/app/views/shared/text_widget.dart';
import 'package:home_automation/common/colors.dart';
import 'package:home_automation/screens/home_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentIndex = 0;
  static List<Widget> pages = [
    const HomePage(),
    const SecurityScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: pages[currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: BottomAppBar(
            surfaceTintColor: AppColors.grey,
            color: AppColors.grey,
            elevation: 10,
            child: Row(children: [
              Expanded(
                  child: GestureDetector(
                onTap: () => _onItemTapped(0),
                child: Column(
                  children: [
                    Icon(
                      Icons.home,
                      color:
                          currentIndex == 0 ? Colors.white : AppColors.dullGrey,
                      size: currentIndex == 0 ? 30 : 25,
                    ),
                    const Spacer(),
                    CustomTextWidget(
                      text: "Home",
                      color:
                          currentIndex == 0 ? Colors.white : AppColors.dullGrey,
                    ),
                  ],
                ),
              )),
              Expanded(
                child: GestureDetector(
                  onTap: () => _onItemTapped(1),
                  child: Column(
                    children: [
                      Icon(
                        Icons.security,
                        color: currentIndex == 1
                            ? Colors.white
                            : AppColors.dullGrey,
                        size: currentIndex == 1 ? 30 : 25,
                      ),
                      const Spacer(),
                      CustomTextWidget(
                        text: "Security",
                        color: currentIndex == 1
                            ? Colors.white
                            : AppColors.dullGrey,
                      ),
                    ],
                  ),
                ),
              ),

              // showSelectedLabels: true,
              // type: BottomNavigationBarType.shifting,
              // unselectedItemColor: Colors.grey,
              // backgroundColor: AppColors.grey,
              // selectedIconTheme: const IconThemeData(color: Colors.white),
              // selectedLabelStyle: const TextStyle(color: Colors.white),
              // items: const <BottomNavigationBarItem>[
              //   BottomNavigationBarItem(
              //     icon: Icon(Icons.home),
              //     label: 'Home',
              //   ),
              //   BottomNavigationBarItem(
              //     icon: Icon(Icons.security),
              //     label: 'Security',
              //   ),
              // ],
              // currentIndex: currentIndex,
              // selectedItemColor: Colors.white,
              // showUnselectedLabels: true,
              // onTap: _onItemTapped,
            ])),
      ),
    );
  }
}
