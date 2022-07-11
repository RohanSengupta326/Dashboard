import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabStyleTwo extends StatelessWidget {
  var isSelectedTodayTab = false.obs;
  var isSelectedWeekTab = false.obs;
  var isSelectedMonthTab = false.obs;
  var isSelectedMonthsTab = false.obs;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          // when hovering mouse cursor changes
          child: GestureDetector(
            onTap: () {
              isSelectedTodayTab.value = !isSelectedTodayTab.value;
              isSelectedWeekTab.value = false;
              isSelectedMonthTab.value = false;
              isSelectedMonthsTab.value = false;
            },
            child: Obx(
              () {
                return Container(
                  height: isSelectedTodayTab.value ? 55 : 50,
                  width: isSelectedTodayTab.value ? 65 : 60,
                  child: Center(
                      child: Text(
                    'Today',
                    style: isSelectedTodayTab.value
                        ? TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          )
                        : TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                  )),
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          // when hovering mouse cursor changes
          child: GestureDetector(
            onTap: () {
              isSelectedTodayTab.value = false;
              isSelectedWeekTab.value = !isSelectedWeekTab.value;
              isSelectedMonthTab.value = false;
              isSelectedMonthsTab.value = false;
            },
            child: Obx(
              () {
                return Container(
                  height: isSelectedWeekTab.value ? 55 : 50,
                  width: isSelectedWeekTab.value ? 65 : 60,
                  child: Center(
                      child: Text(
                    'Week',
                    style: isSelectedWeekTab.value
                        ? TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          )
                        : TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                  )),
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          // when hovering mouse cursor changes
          child: GestureDetector(
            onTap: () {
              isSelectedTodayTab.value = false;
              isSelectedWeekTab.value = false;
              isSelectedMonthTab.value = !isSelectedMonthTab.value;
              isSelectedMonthsTab.value = false;
            },
            child: Obx(
              () {
                return Container(
                  height: isSelectedMonthTab.value ? 55 : 50,
                  width: isSelectedMonthTab.value ? 65 : 60,
                  child: Center(
                      child: Text(
                    'Month',
                    style: isSelectedMonthTab.value
                        ? TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          )
                        : TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                  )),
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          // when hovering mouse cursor changes
          child: GestureDetector(
            onTap: () {
              isSelectedTodayTab.value = false;
              isSelectedWeekTab.value = false;
              isSelectedMonthTab.value = false;
              isSelectedMonthsTab.value = !isSelectedMonthsTab.value;
            },
            child: Obx(
              () {
                return Container(
                  height: isSelectedMonthsTab.value ? 55 : 50,
                  width: isSelectedMonthsTab.value ? 75 : 70,
                  child: Center(
                      child: FittedBox(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '3 Months',
                        style: isSelectedMonthsTab.value
                            ? TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              )
                            : TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                    ),
                  )),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
