import 'dart:async';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:thakeren/Constant/Colors.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:thakeren/Initializations/HiveServices.dart';
import 'package:thakeren/Initializations/LoadingIndicator.dart';
import 'package:thakeren/Initializations/Location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Location _location;
  late Timer _timer; // Add this line

  @override
  void initState() {
    super.initState();
    _location = Location();
    HiveServices();
    _fetchLocationData();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _location.time = _location.getCurrentTime();
        print("Time updated");
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchLocationData() async {
    _location.getPermission();
    await _location.getLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorsPal.G1),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_location.getLocationInfo()['city'] == "" ||
                  _location.getLocationInfo()['country'] == "")
                _getPermission(),
              _UserLocation(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              buildTimeline(),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              prayerDivider(),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              PrayTimesBuild(
                PrayTimes("الفجر", "2:50", Icon(Icons.wb_sunny_outlined)),
                PrayTimes("الشروق", "5:50", Icon(Icons.wb_sunny_outlined)),
                PrayTimes("الظهر", "12:50", Icon(Icons.wb_sunny_outlined)),
                PrayTimes("العصر", "3:50", Icon(Icons.wb_sunny_outlined)),
                PrayTimes("المغرب", "6:50", Icon(Icons.wb_sunny_outlined)),
                PrayTimes("العشاء", "8:50", Icon(Icons.wb_sunny_outlined)),
                PrayTimes("القيام", "12:50", Icon(Icons.wb_sunny_outlined)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget prayerDivider() {
    return AnimationConfiguration.staggeredGrid(
      position: 1,
      columnCount: 1,
      child: SlideAnimation(
        verticalOffset: 50.0,
        duration: const Duration(milliseconds: 500),
        child: FadeInAnimation(
          duration: const Duration(milliseconds: 500),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.001,
                decoration: BoxDecoration(
                  color: const Color(ColorsPal.G4),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                child: Text(
                  "أوقات الصلاة",
                  style: TextStyle(
                    color: const Color(ColorsPal.G4),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Almarai",
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.23,
                height: MediaQuery.of(context).size.height * 0.001,
                decoration: BoxDecoration(
                  color: const Color(ColorsPal.G4),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPermission() {
    return AnimationConfiguration.staggeredGrid(
      position: 1,
      columnCount: 1,
      child: SlideAnimation(
        verticalOffset: 50.0,
        duration: const Duration(milliseconds: 500),
        child: FadeInAnimation(
          duration: const Duration(milliseconds: 500),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                color: const Color(ColorsPal.G2),
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.03,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: const Color(ColorsPal.G4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _location.getPermission();
                          _fetchLocationData();
                        });
                        print("Permission button pressed");
                      },
                      icon: Icon(
                        Icons.location_on,
                        color: const Color(ColorsPal.G1),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      "قم بتفعيل الصلاحيات للوصول للموقع الجغرافي",
                      style: TextStyle(
                        color: const Color(ColorsPal.G1),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Almarai",
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget PrayTimesBuild(
    Widget P1,
    Widget P2,
    Widget P3,
    Widget P4,
    Widget P5,
    Widget P6,
    Widget P7,
  ) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.55,
        child: GridView.count(
          crossAxisCount: 2,
          addAutomaticKeepAlives: true,
          mainAxisSpacing: MediaQuery.of(context).size.height * 0.02,
          crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.05,
            left: MediaQuery.of(context).size.width * 0.05,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          childAspectRatio: 2.5 / 1.5,
          children: [
            P1,
            P2,
            P3,
            P4,
            P5,
            P6,
            P7,
          ],
        ),
      ),
    );
  }

  Widget PrayTimes(String title, String time, Icon icon) {
    return AnimationConfiguration.staggeredGrid(
      position: 1,
      columnCount: 1,
      child: SlideAnimation(
        verticalOffset: 50.0,
        duration: const Duration(milliseconds: 500),
        child: FadeInAnimation(
          duration: const Duration(milliseconds: 500),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(ColorsPal.G4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon.icon,
                      color: const Color(ColorsPal.G1),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Container(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: const Color(ColorsPal.G1),
                          fontSize: 20,
                          fontFamily: "Almarai",
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: const Color(ColorsPal.G1),
                  thickness: 0.6,
                  indent: MediaQuery.of(context).size.width * 0.05,
                  endIndent: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  child: Text(
                    time,
                    style: TextStyle(
                      color: const Color(ColorsPal.G1),
                      fontSize: 20,
                      fontFamily: "Almarai",
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _UserLocation() {
    return AnimationConfiguration.staggeredGrid(
      position: 1,
      columnCount: 1,
      child: SlideAnimation(
        child: FadeInAnimation(
          duration: const Duration(milliseconds: 500),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                color: const Color(ColorsPal.G4),
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _location.time ?? "جاري التحميل",
                        style: TextStyle(
                          color: const Color(ColorsPal.G1),
                          fontSize: 20,
                          fontFamily: "Almarai",
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        _location.date ?? "جاري التحميل",
                        style: TextStyle(
                          color: const Color(ColorsPal.G1),
                          fontSize: 20,
                          fontFamily: "Almarai",
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.002,
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: const Color(ColorsPal.G1),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _location.getLocationInfo()['country'] ??
                            "جاري التحميل",
                        style: TextStyle(
                          color: const Color(ColorsPal.G1),
                          fontSize: 20,
                          fontFamily: "Almarai",
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        _location.getLocationInfo()['city'] ?? "جاري التحميل",
                        style: TextStyle(
                          color: const Color(ColorsPal.G1),
                          fontSize: 20,
                          fontFamily: "Almarai",
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
Widget buildTimeline() {
    return AnimationConfiguration.staggeredGrid(
      position: 1,
      columnCount: 1,
      child: SlideAnimation(
        verticalOffset: 50.0,
        duration: const Duration(milliseconds: 500),
        child: FadeInAnimation(
          duration: const Duration(milliseconds: 500),
          child: EasyDateTimeLine(
            initialDate: DateTime.now(),
            headerProps: EasyHeaderProps(
              centerHeader: true,
              showHeader: true,
              showSelectedDate: false,
              monthPickerType: MonthPickerType.switcher,
              monthStyle: TextStyle(
                color: const Color(ColorsPal.G4),
                fontSize: 20,
                fontWeight: FontWeight.w100,
                fontFamily: "Almarai",
              ),
            ),
            activeColor: const Color(ColorsPal.G4),
            onDateChange: (DateTime date) {
              print(date);
            },
            locale: "ar",
            itemBuilder:
                (context, dayNumber, dayName, monthName, fullDate, isSelected) {
              final arabicNumbers = DateFormat('d', 'ar').format(fullDate);
        
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: MediaQuery.of(context).size.width * 0.18,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(ColorsPal.G4)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(ColorsPal.G4),
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                        fontFamily: "Almarai",
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      arabicNumbers,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(ColorsPal.G4),
                        fontSize: 20,
                        fontFamily: "Almarai",
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    //SizedBox(
                    //  height: MediaQuery.of(context).size.height * 0.01,
                    //),
                    // Text(
                    //   monthName,
                    //   style: TextStyle(
                    //     color:
                    //         isSelected ? Colors.white : const Color(ColorsPal.G4),
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.w100,
                    //     fontFamily: "Almarai",
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}
