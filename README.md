## Puftel

## This repository
This is the basic version of Puftel, the app as it currently exists in the App Store and
Play Store. This repository is primarily for reference and learning purposes, however you may
alter or redistribute this app, under the condition that you do not charge for the app and that
you maintain the credits as is, that means you ensure that the text of the about view and the
donation and web reference links will remain in the app.

# https://play.google.com/store/apps/details?id=nl.mikerworks.puftel&hl=en_US

# https://apps.apple.com/ca/app/puftel/id6469622485


## About this app and why I developed it
This app was developed by Miker Works (and released under the name Finiware, my other company). 

I developed this app because my son has asthma and needs various medications through a 
spacer (puffs) every day. Of course you keep track of it on paper, but there is an app 
for that as of now. 

This app keeps track of how much has been used per medicine and can 
therefore indicate when a new medicine is needed. Often the maximum number of puffs is 200.
This is the default amount in the app. However, you can adjust this yourself. 
This also applies to the number for warning level: the moment at which the counter changes 
color so that you can order additional medications from the pharmacy or doctor in a timely 
manner. 

Be sure to read the disclaimer: 
You are responsible for correct administration of the necessary medications. 
If in doubt, always consult your doctor. You can add additional medications to the counter 
list yourself. You will find some of them in the list if you click on the button, 
such as salbutamol, qvar and foster. You can add other medications yourself. 

You can adjust the data for each medicine counter, such as the name, description and color.
You can also reset or correct the counter via the settings screen. To do this, press the 
pencil button in the overview screen. All counters can be found in the overview screen.
There you can quickly see the current counter reading, but also increase the counter by 1 or 4 
puffs. 

The menu options, including the logbook,
are visible via the menu button at the top left. This contains the date and time, the medicine 
and the amount of medicine. 

I hope this app is useful for you too. Rotterdam, October 2023, Mike van Drongelen


## Further development
I have many more ideas to make Puftel the app for tracking, reminding, logging and analytical
purposes so asthma and simular diseases can be easily monitored and perhaps even to find what
possible trigger points are. Think, for example, a connection with air quality API's and such.

If you like to contribute to this project or if you need more info,
you can drop me a line at: info @ mikerworks.nl


## Project setup

# Prerequisites: 
Android Studio (or VS Code), Xcode + Xcode command line tools configured (if you want to compile
for IOS), access to the Apple Development program (if you want to test the app on a physical 
device or if you want to distribute it), Flutter 3.10.6 or up

The app is written with Android Studio for macOS IDE, in Dart, using the Flutter framework. 
It runs on both iOS and Android (and probably with some modifications on web or desktop as well)

1. In a terminal run 'flutter pub get' to get all the dependencies. 
(or in Android Studio open pubspec.yaml and click on the 'pub get' link on the top of  the editor screen).
2. In a terminal run 'flutter gen-l10n' to generate all localization resource files. 
These are based on the .arb files as found in the l10n folder.
3. In Android Studio ensure that the compileSDK version (as defined in the build.gradle) is 
installed or use SDK Manager (accesible through the Tools menu of Android Studio) ) to do so.


Note: I am no longer using build variants for Puftel.nl and Puff Counter. 
For the sake of simplicity it now is just Puftel, supporting both dutch (NL) and English (EN)
and other languages (yours?) in the future.

