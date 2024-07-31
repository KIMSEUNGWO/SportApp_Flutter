import 'package:url_launcher/url_launcher.dart' as url;

class OpenApp {

  static const String homeLat = "37.4689290";
  static const String homeLng = "126.7104680";
  static const String googleApp = 'comgooglemaps://';
  launchURL() async {

    const String openApp = 'comgooglemaps://?q=$homeLat,$homeLng';
    const String openApp2 = 'comgooglemaps://?q=간석여자중학교';
    url.launchUrl(Uri.parse(openApp2));
  }
}
