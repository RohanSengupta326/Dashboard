import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  final GlobalKey _menuKey = GlobalKey();

  var toggleButtonValueOne = false.obs;
  var toggleButtonValueTwo = false.obs;
  var toggleButtonValueThree = false.obs;
  var toggleButtonValueFour = false.obs;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () {
            return ToggleButtons(
              key: _menuKey,
              isSelected: [
                toggleButtonValueOne.value,
                toggleButtonValueTwo.value,
                toggleButtonValueThree.value,
                toggleButtonValueFour.value,
              ],
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              fillColor: Colors.lightGreen,
              hoverColor: Colors.grey,
              onPressed: (index) {
                if (index == 0) {
                  toggleButtonValueOne.value = !toggleButtonValueOne.value;
                  toggleButtonValueTwo.value = false;
                  toggleButtonValueThree.value = false;
                  toggleButtonValueFour.value = false;
                } else if (index == 1) {
                  toggleButtonValueOne.value = false;
                  toggleButtonValueTwo.value = !toggleButtonValueTwo.value;
                  toggleButtonValueThree.value = false;
                  toggleButtonValueFour.value = false;
                } else if (index == 2) {
                  toggleButtonValueOne.value = false;
                  toggleButtonValueTwo.value = false;
                  toggleButtonValueThree.value = !toggleButtonValueThree.value;
                  toggleButtonValueFour.value = false;
                } else if (index == 3) {
                  toggleButtonValueOne.value = false;
                  toggleButtonValueTwo.value = false;
                  toggleButtonValueThree.value = false;
                  toggleButtonValueFour.value = !toggleButtonValueFour.value;
                }
              },
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Today',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Week',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Months',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      '3 Months',
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            );
          },
        ),
      ],
    );
  }
}
