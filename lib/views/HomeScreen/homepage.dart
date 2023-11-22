import 'package:banky/views/HomeScreen/cardsScreen.dart';
import 'package:banky/views/HomeScreen/homeScreen.dart';
import 'package:banky/views/HomeScreen/profileScreen.dart';
import 'package:banky/views/HomeScreen/settingsScreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String? userName;
  const HomePage({
    super.key, this.userName,
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
            selectedItemColor: Color.fromRGBO(28, 78, 191, 1),
            selectedIconTheme:
                IconThemeData(color: Color.fromRGBO(28, 78, 191, 1)),
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
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
                    'assets/icons/4753733_business_card_credit_credit card_dollar_icon.png',
                    width: 24,
                    height: 24),
                label: 'Credit',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                    'assets/icons/9035575_settings_outline_icon.png',
                    width: 24,
                    height: 24),
                label: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
