import 'package:core/ui_elements/custom_toast.dart';

class UDPMessageHandler {
  UDPMessageHandler();

  void handle(String message) {
    RegExp bracketsRegExp = RegExp(r'\[([^\]]*)\]');
    Iterable<RegExpMatch> matches = bracketsRegExp.allMatches(message);

    if (matches.isNotEmpty) {
      String flagContent = matches.elementAt(0).group(1) ?? '';
      String vehicleContent =
          matches.length > 1 ? matches.elementAt(1).group(1) ?? '' : '';
      String vehicleId = "[${vehicleContent.split('-')[0]}]";
      CustomToast().showStatusToast(message, flagContent, vehicleId);
    } else {
      CustomToast()
          .showFlutterToast('Square brackets were not found in the text');
    }
  }

  void handleLocationMessage(String message) {
    RegExp regExp = RegExp(r"'latitude': (\d+\.\d+), 'longitude': (\d+\.\d+)");
    var match = regExp.firstMatch(message);
    if (match != null) {
      final latitude = double.parse(match.group(1)!);
      final longitude = double.parse(match.group(2)!);
      CustomToast().showFlutterToast('$latitude, $longitude');
    } else {
      CustomToast().showFlutterToast('The location format is not correct.');
    }
  }
}
