import 'package:flutter/material.dart';
import 'package:puftel/app/app_storage.dart';
import 'package:puftel/ui/dashboard/dashboard_view.dart';
import 'app/app_routes.dart';
import 'app/event_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  static late AppLocalizations local;
  static EventBloc eventBloc = EventBloc();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppStorage.setIsInternational();

    return MaterialApp(
        title: "App",
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en')
        ],

        routes: AppRoutes.routes,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:DashboardView(title: '')
    );
  }
}