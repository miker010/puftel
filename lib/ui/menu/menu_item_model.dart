class MenuItemModel {
  MenuItemModel({
    required this.id,
    required this.title,
    required this.appRoute,
    this.badge,
    this.customAction
  });

  String id;
  String title;
  String appRoute;
  String? badge;
  String? customAction;
}