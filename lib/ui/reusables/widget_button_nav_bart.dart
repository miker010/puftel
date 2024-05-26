import 'package:flutter/material.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';

class WidgetButtonNavBar extends StatelessWidget{
  WidgetButtonNavBar({
    required this.icon,
    required this.onClicked,
    required this.title
  });

  final GestureTapCallback onClicked;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(title, style: TextStyle(color: AppColors.appPrimaryColorWhite)),
                AppDimensions.horizontalSmallSpacer,
                Icon(
                    icon,
                    color: AppColors.appPrimaryColorWhite
                ),
              ],
            )
        ),
        onPressed: onClicked
    );
  }
}