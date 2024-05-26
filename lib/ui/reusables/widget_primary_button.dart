import 'package:flutter/material.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';

class WidgetPrimaryButton extends StatelessWidget{
  WidgetPrimaryButton({
    required this.labelText,
    required this.onClicked,
    this.fillColor = AppColors.appPrimaryColor,
    this.splashColor = AppColors.appPrimaryColorBlueLight,
    this.labelColor = AppColors.appPrimaryColorWhite,
    this.leadingIcon
  });

  final String labelText;
  final GestureTapCallback onClicked;
  final Color fillColor ;
  final Color splashColor;
  final Color labelColor;
  final Icon? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        fillColor: fillColor,
        splashColor: splashColor,
        child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingSmall),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                (leadingIcon !=null)? leadingIcon! : Container(),
                (leadingIcon !=null)? SizedBox(width: AppDimensions.paddingSmall) : Container(),
                Text(labelText,
                    maxLines: 1,
                    style: TextStyle(
                        color: labelColor,
                        fontWeight: FontWeight.bold)
                )
              ],
            )
        ),
        onPressed: onClicked
    );
  }
}