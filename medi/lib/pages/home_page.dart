import 'package:flutter/material.dart';
import 'package:medi/components/medi_constants.dart';
import 'package:medi/pages/add/add_medicine_page.dart';
import 'package:medi/pages/history/history_page.dart';
import 'package:medi/pages/today/today_page.dart';

import '../components/medi_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _pages = [
    const TodayPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Scaffold(
        body: Padding(
          padding: pagePadding,
          child: SafeArea(child: _pages[_currentIndex]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onAddMedicine,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _buildBottomAppBar(),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
        elevation: 5,
        child: Container(
          height: kBottomNavigationBarHeight,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () {
                  _onCurrentPage(0);
                },
                child: Icon(
                  Icons.check,
                  color: _currentIndex == 0
                      ? MediColors.primaryColor
                      : Colors.grey,
                ),
              ),
              MaterialButton(
                child: Icon(
                  Icons.fact_check_rounded,
                  color: _currentIndex == 1
                      ? MediColors.primaryColor
                      : Colors.grey,
                ),
                onPressed: () {
                  _onCurrentPage(1);
                },
              ),
            ],
          ),
        ));
  }

  void _onCurrentPage(int pageIndex) {
    _currentIndex = pageIndex;
    setState(() {});
  }

  void _onAddMedicine() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddMedicinePage()));
  }
}
