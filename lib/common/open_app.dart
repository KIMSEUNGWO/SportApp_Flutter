
import 'package:url_launcher/url_launcher.dart';

class OpenApp {

  // 테스트용
  static const String homeLat = "35.757721";
  static const String homeLng = "139.527805";

  openMaps() async {

    Uri googleMap = google(homeLat, homeLng);
    if (await canLaunchUrl(googleMap)) {
      launchUrl(googleMap);
      return;
    }

    Uri appleMap = apple(homeLat, homeLng);
    if (await canLaunchUrl(appleMap)) {
      launchUrl(appleMap);
      return;
    }

  }

  google(String lat, String lng) {
    return Uri.parse('comgooglemaps://?q=$lat,$lng');
  }

  apple(String lat, String lng) {
    return Uri.parse('maps://?q=$lat,$lng');
  }
}
