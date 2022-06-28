import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class UtcMs {
  Map<String, dynamic>? data;

  Future<void> fetchData(DateTimeRange date, TimeRange time) async {
    String startDateTimeUtc = DateTime(date.start.day).toIso8601String();
    

    var startUtc = date.start.toUtc();
    var endUtc = date.end.toUtc();
    var startMs = time.startTime.minute * 60000;
    var endMs = time.endTime.minute * 60000;

    String urL = 'API_HERE';
    var url = Uri.parse(
      urL,
    );
    Map<String, String> dateFilter = {
      'startDate': startUtc.toIso8601String(),
      'endDate': endUtc.toIso8601String(),
      'startTime': startMs.toString(),
      'endTime': endMs.toString()
    };
    try {
      final response = await http.get(url, headers: dateFilter);

      print(response.statusCode);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        if (extractedData == null) {
          Get.snackbar('Error', 'Could not load data');
          return;
        } else if (response.statusCode > 400) {
          Get.snackbar('error', 'some error occurred');
        }
      }
    } catch (error) {
      print(error);
      throw (error);
    }
    // put extracted data to result(map declared) and pass the data to the graphs and rebuild theme accordingly.
  }
}
