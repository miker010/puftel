import 'package:flutter/material.dart';
import 'package:puftel/main.dart';
import 'package:puftel/ui/about/about_view.dart';
import 'package:puftel/ui/charts/chart_view.dart';
import 'package:puftel/ui/dashboard/dashboard_view.dart';
import 'package:puftel/ui/disclaimer/disclaimer_view.dart';
import 'package:puftel/ui/log/log_list_view.dart';
import 'package:puftel/ui/medicine/medicine_add_view.dart';
import 'package:puftel/ui/medicine/medicine_list_view.dart';
import 'package:puftel/ui/mood/report/mood_report_list_item.dart';
import 'package:puftel/ui/mood/report/mood_report_list_view.dart';
import 'package:puftel/ui/today/today_list_view.dart';

import '../ui/counter/counter_detail_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String CUSTOM_ACTION_LOGOUT = "LOGOUT";

  static const String about = "/about";
  static const String dashboard = "/dashboard";
  static const String counterDetails = "/counterDetails";
  static const String medicineList = "/medicineList";
  static const String medicineAdd = "/medicine/add";
  static const String logList = "/logList";
  static const String disclaimer = "/disclaimer";
  static const String todayReport = "/todayReport";
  static const String moodReport = "/moodReport";

  static const String chart = "/chart";

  static final routes = <String, WidgetBuilder>{
    about      : (BuildContext context) => AboutView(title: MyApp.local.menu_about),
    disclaimer      : (BuildContext context) => DisclaimerView(title: MyApp.local.menu_disclaimer),
    logList         : (BuildContext context) => LogListView(title: MyApp.local.menu_log),

    todayReport     : (BuildContext context) => TodayListView(title: "TODO"),
    moodReport      : (BuildContext context) => MoodReportListView(title: "TODO"),
    chart           : (BuildContext context) => ChartView(title: "TODO"),

    dashboard       : (BuildContext context) => DashboardView(title: MyApp.local.menu_overview),
    medicineList    : (BuildContext context) => MedicineListView(title: MyApp.local.menu_medicines),
    medicineAdd     : (BuildContext context) => MedicineAddView(),
    counterDetails  : (BuildContext context) => CounterDetailView(title: MyApp.local.counter_detail_caption),
  };
}