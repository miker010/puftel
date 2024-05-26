import 'package:rxdart/rxdart.dart';
import 'event_result_model.dart';

class EventBloc {
  final _fetcher = PublishSubject<EventResultModel?>();
  Stream<EventResultModel?> get result => _fetcher.stream;
  final _fetcher401 = PublishSubject<EventResultModel?>();
  Stream<EventResultModel?> get result401 => _fetcher401.stream;

  set401Event(String target, int code, String message) async {
    var model = EventResultModel(
        eventCode: code,
        eventTarget: target,
        eventMessage: message);
    _fetcher401.sink.add(model);
  }

  setEvent(String target, int code, String message) async {
    var model = EventResultModel(
        eventCode: code,
        eventTarget: target,
        eventMessage: message);
    _fetcher.sink.add(model);
  }

  dispose() {
    _fetcher.close();
  }
}