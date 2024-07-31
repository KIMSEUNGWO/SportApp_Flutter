import 'package:url_launcher/url_launcher.dart' as url;

class OpenApp {

  static const String homeLat = "35.757721";
  static const String homeLng = "139.527805";
  static const String googleApp = 'comgooglemaps://';
  launchURL() async {

    const String openApp = 'comgooglemaps://?q=$homeLat,$homeLng';
    const String openApp2 = 'comgooglemaps://?q=Minamisawa Ave.';
    url.launchUrl(Uri.parse(openApp));
  }
}
