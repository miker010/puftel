import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:puftel/app/app_colors.dart';
import 'package:puftel/app/app_dimensions.dart';
import 'package:puftel/app/app_messages.dart';
import 'package:puftel/db/bloc/log_bloc.dart';
import 'package:puftel/db/models/medicine_model.dart';
import 'package:puftel/main.dart';
import 'package:url_launcher/url_launcher.dart';

typedef void OnMedicineSelected(MedicineModel model);

class MedicineListItem extends StatelessWidget {

  MedicineListItem({
    required this.item,
    required this.onMedicineSelected,
    this.canSelect = true,
    this.badgeColor = AppColors.appPrimaryColorGreen
  });

  MedicineModel item;
  bool canSelect;
  Color badgeColor;
  OnMedicineSelected onMedicineSelected;

  var logBloc = LogBloc();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          onMedicineSelected(item);
        },
        child:  Container(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.appPrimaryColorGrey,
              border: Border.all(color: AppColors.appPrimaryBackgroundColor),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 10,
                  child: Container(
                      padding: EdgeInsets.all(AppDimensions.paddingSmall),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: AppColors.getColor(item.color),
                            shape: BoxShape.circle
                        ),
                      )
                  )
              ),
              Expanded(
                  flex : 75,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: TextStyle(
                        color: AppColors.getColor(item.color),
                        fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                    AppDimensions.verticalSmallSpacer,
                    Text(item.description.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal)
                    ),
                    AppDimensions.verticalSmallSpacer,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppDimensions.paddingMedium),
                      decoration: BoxDecoration(
                          color: AppColors.getColor(item.color)
                      ),
                      child: Text(
                        MyApp.local.medicine_list_item_add,
                        style: TextStyle(
                            color: AppColors.appPrimaryColorWhite)
                      ),
                    )
                ],
                )
              ),
              Expanded(
                  flex: 15,
                  child: (item.link == null || item.link.length<=0)?
                    Container():
                    Container(
                      padding: EdgeInsets.all(AppDimensions.paddingSmall),
                      child: Material(
                        child: InkWell(
                          onTap: () async {
                            if (item.link != null && item.link.length>0) {
                              final Uri url = Uri.parse(item.link);
                              if (!await launchUrl(url)) {
                               AppMessages.quickNotify(
                                context,
                                MyApp.local.menu_cannot_load_site + " ${item.link}");
                              }
                            }
                          },
                          child: Icon(Icons.link),
                        ),
                      )
                  )
              ),
            ],
          )
        )
      ),
    );
  }
}