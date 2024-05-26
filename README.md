# puftel


## Project setup
1. In a terminal run 'flutter pub get' to get all the dependencies. (or in Android Studio open pubspec.yaml and click on the 'pub get' link on the top of
   the editor screen.
2. In a terminal run 'flutter gen-l10n' to generate all localization resource files. These are based on the .arb files as found in the l10n folder.
3. In Android Studio ensure that the compileSDK version (as defined in the build.gradle) is installed or use SDK Manager (accesible through the Tools menu of
   Android Studio) ) to do so.
4. 
   puftel

## Getting Started

Puftel.nl
- nl.mikerworks.puftel
- Use the menu options to debug, release, bundle the app

## Project setup
1. In a terminal run 'flutter pub get' to get all the dependencies. (or in Android Studio open pubspec.yaml and click on the 'pub get' link on the top of
   the editor screen.
2. In a terminal run 'flutter gen-l10n' to generate all localization resource files. These are based on the .arb files as found in the l10n folder.
3. In Android Studio ensure that the compileSDK version (as defined in the build.gradle) is installed or use SDK Manager (accesible through the Tools menu of
   Android Studio) ) to do so.
4. 

---


Obsolete:

- Puff Counter
  nl.mikerworks.puffcounter

iOS:

flutter build ios --target lib/main_puffcounter.dart --flavor puffcounter


to run in release mode:
flutter run --release lib/main_puffcounter.dart --flavor puffcounter

to run in debug mode:
flutter run -t lib/main_puffcounter.dart --flavor puffcounter (debug)

to create a bundle (AAB):
flutter build appbundle  lib/main_puffcounter.dart --flavor puffcounter

No longer using build variants for Puftel.nl and Puff Counter. For the sake of simplicity it now is
just puftel, supporting both NL and EN (and other languages in the future)

---

Objectives 1.10

- Foster, 120 ipv 200, in tekst zetten en in medicijnlijst
- Luchtkwaliteit API + monitoring
- De puf loopt leeg dus terug visualeren balk
- Editable logentries
- 
- Doorklikken van rapport smileys -> log
- Apart scherm voor titel en beschrijving ipv popup
- Cancel button bij popup kleur
