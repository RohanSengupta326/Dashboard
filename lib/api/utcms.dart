import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class PostRequestInUtcMillisecond {
  Map<String, dynamic>? data;

  Future<void> fetchData(DateTimeRange date, TimeRange time) async {
    String startDateTimeUtc = DateTime(date.start.day).toUtc().toString();
    String startDateTimeMilliseconds =
        DateTime(date.start.day).millisecond.toString();

    String endDateTimeUtc = DateTime(date.end.day).toUtc().toString();
    String endDateTimeMilliseconds =
        DateTime(date.end.day).millisecond.toString();

    String urL = 'API_HERE';
    var url = Uri.parse(
      urL,
    );
    Map<String, String> dateFilter = {
      'startDate': startDateTimeUtc,
      'endDate': endDateTimeUtc,
      'startTime': startDateTimeMilliseconds,
      'endTime': endDateTimeMilliseconds,
    };
    try {
      final response = await http.post(url, body: json.encode(dateFilter));

      print(response.statusCode);

      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);

        if (extractedData == null) {
          Get.snackbar('Error', 'Could not load data');
          return;
        } else if (response.statusCode > 400) {
          Get.snackbar('error', 'some error occurred');
        }
        // json.decode extracted data to result(map declared) and pass the data to the graphs and rebuild theme accordingly.
      }
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
