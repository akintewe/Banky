import 'package:banky/views/HomeScreen/cardsScreen.dart';
import 'package:banky/views/HomeScreen/homeScreen.dart';
import 'package:banky/views/HomeScreen/profileScreen.dart';
import 'package:banky/views/HomeScreen/settingsScreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String? userName;
  const HomePage({
    super.key,
    this.userName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      CardsScreen(),
      SettingsScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedLabelStyle: TextStyle(color: Colors.black),
            unselectedItemColor: Colors.black,
            selectedItemColor: Color.fromRGBO(28, 78, 191, 1),
            selectedIconTheme:
                IconThemeData(color: Color.fromRGBO(28, 78, 191, 1)),
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/icons/3844470_home_house_icon.png',
                    width: 24, height: 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                    'assets/icons/4753733_business_card_credit_credit card_dollar_icon.png',
                    width: 24,
                    height: 24),
                label: 'Collections',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                    'assets/icons/9035575_settings_outline_icon.png',
                    width: 24,
                    height: 24),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                    'assets/icons/4092564_profile_about_mobile ui_user_icon.png',
                    width: 24,
                    height: 24),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
