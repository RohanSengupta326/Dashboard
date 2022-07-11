import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabFourStyle extends StatelessWidget {
  var isSelectedTodayTab = false.obs;
  var isSelectedWeekTab = false.obs;
  var isSelectedMonthTab = false.obs;
  var isSelectedMonthsTab = false.obs;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          return TextButton(
            onHover: (value) {},
            style: ButtonStyle(
              elevation:
                  MaterialStateProperty.all(isSelectedTodayTab.value ? 7 : 0),
            ),
            onPressed: () {
              isSelectedTodayTab.value = !isSelectedTodayTab.value;
              isSelectedWeekTab.value = false;
              isSelectedMonthTab.value = false;
              isSelectedMonthsTab.value = false;
            },
            child: Text(
              'Today',
              style: isSelectedTodayTab.value
                  ? TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                      decoration: TextDecoration.underline)
                  : TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black),
            ),
          );
        }),
        SizedBox(
          width: 5,
        ),
        Obx(() {
          return TextButton(
            onHover: (value) {},
            style: ButtonStyle(
              elevation:
                  MaterialStateProperty.all(isSelectedWeekTab.value ? 7 : 0),
            ),
            onPressed: () {
              isSelectedTodayTab.value = false;
              isSelectedWeekTab.value = !isSelectedWeekTab.value;
              isSelectedMonthTab.value = false;
              isSelectedMonthsTab.value = false;
            },
            child: Text(
              'Week',
              style: isSelectedWeekTab.value
                  ? TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                      decoration: TextDecoration.underline)
                  : TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black),
            ),
          );
        }),
        SizedBox(
          width: 5,
        ),
        Obx(() {
          return TextButton(
            onHover: (value) {},
            style: ButtonStyle(
              elevation:
                  MaterialStateProperty.all(isSelectedMonthTab.value ? 7 : 0),
            ),
            onPressed: () {
              isSelectedTodayTab.value = false;
              isSelectedWeekTab.value = false;
              isSelectedMonthTab.value = !isSelectedMonthTab.value;
              isSelectedMonthsTab.value = false;
            },
            child: Text(
              'Month',
              style: isSelectedMonthTab.value
                  ? TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                      decoration: TextDecoration.underline)
                  : TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black),
            ),
          );
        }),
        SizedBox(
          width: 5,
        ),
        Obx(() {
          return TextButton(
            onHover: (value) {},
            style: ButtonStyle(
              elevation:
                  MaterialStateProperty.all(isSelectedMonthsTab.value ? 7 : 0),
            ),
            onPressed: () {
              isSelectedTodayTab.value = false;
              isSelectedWeekTab.value = false;
              isSelectedMonthTab.value = false;
              isSelectedMonthsTab.value = !isSelectedMonthsTab.value;
            },
            child: Text(
              '3 Months',
              style: isSelectedMonthsTab.value
                  ? TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.underline)
                  : TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black),
            ),
          );
        }),
      ],
    );
  }
}
