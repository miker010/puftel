class EventResultModel{

  EventResultModel({
    required this.eventCode,
    required this.eventTarget,
    required this.eventMessage
  });

  late final int eventCode;
  late final String eventTarget;
  late final String eventMessage;
}