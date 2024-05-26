import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_messages.dart';
import 'package:puftel/app/app_routes.dart';
import 'package:puftel/app/app_storage.dart';
import 'package:puftel/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'menu_item_model.dart';

class MenuView extends StatefulWidget {

  String? version;

  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView>{
  final MENU_ID_DASHBOARD = "MENU_ID_DASHBOARD";
  final MENU_ID_MEDICINES = "MENU_ID_MEDICINES";
  final MENU_ID_LOGS = "MENU_ID_LOGS";
  final MENU_ID_CHART = "MENU_ID_CHART";
  final MENU_ID_ABOUTD = "MENU_ID_ABOUTD";
  final MENU_ID_MORE = "MENU_ID_MORE";
  final MENU_ID_SUPPORT = "MENU_ID_SUPPORT";
  final MENU_ID_TODAY = "MENU_ID_TODAY";
  final MENU_ID_MOOD_REPORT = "MENU_ID_MOOD_REPORT";
  final MENU_ID_LOGOUT = "MENU_ID_LOGOUT";
  final MENU_DISCLAIMER = "MENU_DISCLAIMER";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {});
    });
    _getVersion();
  }

  _getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    final String buildNumber = packageInfo.buildNumber;

    setState(() {
      widget.version = "${version} - ${buildNumber}";
    });
  }

  bool isDutch(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'nl';
  }

  @override
  Widget build(BuildContext context) {
    final model = <MenuItemModel>[];
    model.add(MenuItemModel(
        id: MENU_ID_DASHBOARD,
        title: MyApp.local.menu_overview,
        appRoute: AppRoutes.dashboard));
    model.add(MenuItemModel(
        id: MENU_ID_TODAY,
        title: MyApp.local.menu_today,
        appRoute: AppRoutes.todayReport));
    model.add(MenuItemModel(
        id: MENU_ID_LOGS,
        title: MyApp.local.menu_log,
        appRoute: AppRoutes.logList));
    model.add(MenuItemModel(
        id: MENU_ID_MOOD_REPORT,
        title: MyApp.local.mood_how_it_went,
        appRoute: AppRoutes.moodReport));
    model.add(MenuItemModel(
        id: MENU_ID_MEDICINES,
        title: MyApp.local.menu_medicines,
        appRoute: AppRoutes.medicineList));
    model.add(MenuItemModel(
        id: MENU_DISCLAIMER,
        title: MyApp.local.menu_disclaimer,
        appRoute: AppRoutes.disclaimer));
    model.add(MenuItemModel(
        id: MENU_ID_MORE,
        title: MyApp.local.menu_read_more,
        appRoute: AppRoutes.about,
        customAction: "MORE"));

    return Drawer(
        child : Container(
            child : ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: AppColors.appPrimaryColorGreyLight,
                    ),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 52,
                            height: 52,
                            child: (MyApp?.isInternational==true)?
                            Image.asset("assets/appstore_puffcounter.png") :
                            Image.asset("assets/appstore.png"),
                          ),
                          AppDimensions.verticalMediumSpacer,
                          Text(MyApp.local.appTitle,
                            style: TextStyle(
                                color: AppColors.appPrimaryColorBlueDark,
                                fontSize: 24,
                                fontWeight:  FontWeight.bold)
                          ),
                          (widget.version==null)?
                          Container() :
                          Container(
                              margin: EdgeInsets.only(top: 4, left: 0),
                              child: Row(
                                children: [
                                  Text("${MyApp.local.menu_version} ${widget.version}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.appPrimaryColorBlueDark)
                                  )
                                ],
                              )
                          )
                        ]
                      )
                    )
                ),
                for(int i=0;i<model.length;i++)
                  ListTile (
                    title: Row(
                      children: [
                        Text(
                          "${model[i].title}",
                          style: TextStyle(
                              color:AppColors.appPrimaryColorBlueDark)
                        ),
                        AppDimensions.horizontalSmallSpacer,
                        Container()
                      ],
                    ),
                    onTap: () async {
                      Navigator.pop(context);

                      if (model[i].customAction != null){
                        if (model[i].customAction == AppRoutes.CUSTOM_ACTION_LOGOUT){
                        }
                        else if (model[i].customAction == "SUPPORT") {
                          if (!await launchUrl(Uri.parse("https://www.buymeacoffee.com/puftel"))) {
                            AppMessages.quickNotify(context, MyApp.local.menu_cannot_load_site);
                          }
                        }
                        else if (model[i].customAction == "MORE") {
                          final isInternational = await AppStorage.getIsInternational();
                          if (isInternational) {
                            if (!await launchUrl(Uri.parse(
                                "https://www.miker.works/english/apps/puftel"))) {
                              AppMessages.quickNotify(context, MyApp.local
                                  .menu_cannot_load_site);
                            }
                          }
                          else {
                            if (!await launchUrl(Uri.parse(
                                (isDutch(context))?
                                "https://www.miker.works/apps/puftel/index.html" :
                                "https://www.miker.works/english/apps/puftel/index.html"
                                ))) {
                              AppMessages.quickNotify(context, MyApp.local
                                  .menu_cannot_load_site);
                            }
                          }
                        }
                      }
                      else if (model[i].appRoute.length>0){
                        Navigator.pushNamed(context, model[i].appRoute);
                      }
                    },
                  ),
                (Platform.isIOS)?
                Container():
                Container(
                  width: 150,
                  child: Material(
                    child: InkWell(
                      onTap: () async {
                        if (!await launchUrl(Uri.parse("https://www.buymeacoffee.com/puftel"))) {
                        AppMessages.quickNotify(context, MyApp.local.menu_cannot_load_site);
                        }
                      },
                      child: Image.asset("assets/buymeacoffee.png", width: 150)
                    ),
                  ),
                )
              ],
            )
        )
    );
  }
}