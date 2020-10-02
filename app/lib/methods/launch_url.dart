import 'package:url_launcher/url_launcher.dart';

launchURL() async {
  const url =
      'https://play.google.com/store/apps/details?id=io.epix.loan_manager';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
