import 'package:flutter_share/flutter_share.dart';

Future<void> share() async {
  await FlutterShare.share(
      title: 'Loan Manager',
      text: 'Loan Manager',
      linkUrl:
          'https://play.google.com/store/apps/details?id=io.epix.loan_manager',
      chooserTitle: 'Share Loan Manager App');
}
