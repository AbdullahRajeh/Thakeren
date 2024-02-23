import 'package:flutter/material.dart';
import 'package:thakeren/Constant/Colors.dart';
import 'package:thakeren/Pages/HomePage.dart';
import 'package:thakeren/Pages/AthkarPage.dart';
import 'package:thakeren/Pages/QiblahPage.dart';
import 'package:thakeren/Pages/QuranPage.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  int _selectedIndex = 4;

  List<Title> _titles = [
    Title(
      title: 'القرآن',
      Route: QuranPage(),
      isSelected: false,
    ),
    Title(
      title: 'القبلة',
      Route: QiblahPage(),
      isSelected: true,
    ),
    Title(
      title: 'الأذكار',
      Route: AthkarPage(),
      isSelected: false,
    ),
    Title(
      title: 'الأذان',
      Route: HomePage(),
      isSelected: false,
    ),
  ];

  late PageController _pageController;
  bool isStretch = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _selectedIndex,
      viewportFraction: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.15,
              backgroundColor: Color(ColorsPal.G4),
              floating: true,
              pinned: true,
              snap: true,
              onStretchTrigger: () {
                setState(() {
                  isStretch = true;
                });
                return Future<void>.value();
              },
              stretch: isStretch,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  if (!isStretch)
                    Container(
                      margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.08,
                      ),
                      child: Text(
                        'ذاكرين',
                        style: TextStyle(
                          color: Color(ColorsPal.G1),
                          fontSize: 25,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (!isStretch)
                    Divider(
                      color: Color(ColorsPal.G1),
                      thickness: 1,
                      endIndent: 30,
                      indent: 30,
                    ),
                  // Title Row
                  _TitleRow(),
                ],
              ),
            ),
          ];
        },
        body: PageView(
          controller: _pageController,
          children: _titles.map((e) => e.Route).toList(),
          onPageChanged: (index) {
            setState(() {
              // Update selected index
              _titles.forEach((title) {
                title.isSelected = false;
              });
              _titles[index].isSelected = true;
              isStretch = false; // Reset isStretch when the page changes
            });
          },
        ),
      ),
    );
  }

  Widget _TitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _titles.asMap().entries.map((entry) {
        int index = entry.key;
        Title title = entry.value;
        double selectedHeight = _calculateHeight(index);
        double selectedOffset = _calculateOffset(index);

        return InkWell(
          enableFeedback: false,
          onTap: () {
            setState(() {
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
              selectedHeight = _calculateHeight(index);
              selectedOffset = _calculateOffset(index);
            });
          },
          child: Column(
            children: [
              Container(
                child: Text(
                  title.title,
                  style: TextStyle(
                    color: _TitleColor(title.isSelected),
                    fontSize: 15,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              _UnderLine(index, _titles),
              _SpacerContainer(selectedHeight, selectedOffset),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _TitleColor(bool isSelected) {
    if (isSelected) {
      return Color(ColorsPal.G1);
    } else {
      return Colors.grey;
    }
  }

  Widget _UnderLine(int index, List<Title> _titles) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: MediaQuery.of(context).size.height * 0.004,
      width: _calculateWidth(index),
      color: _titles[index].isSelected ? Color(ColorsPal.G1) : Colors.transparent,
    );
  }

  Widget _SpacerContainer(double selectedHeight, double selectedOffset) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: selectedHeight,
      margin: EdgeInsets.only(bottom: selectedOffset),
    );
  }

  double _calculateHeight(int index) {
    return _titles[index].isSelected ? 10.0 : 0.0;
  }

  double _calculateWidth(int index) {
    switch (index) {
      case 0:
        return MediaQuery.of(context).size.width * 0.18;
      case 1:
        return MediaQuery.of(context).size.width * 0.13;
      case 2:
        return MediaQuery.of(context).size.width * 0.13;
      case 3:
        return MediaQuery.of(context).size.width * 0.13;
      default:
        return 0.0;
    }
  }

  double _calculateOffset(int index) {
    return _titles[index].isSelected ? 3.5 : 0.0;
  }
}

class Title {
  String title;
  Widget Route;
  bool isSelected;

  Title({
    required this.title,
    required this.Route,
    required this.isSelected,
  });
}
