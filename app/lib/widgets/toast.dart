import 'package:fluttertoast/fluttertoast.dart';

Future<bool> showToast(String msg) async {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    // backgroundColor: Colors.red,
    // textColor: Colors.white,
    // fontSize: 16.0,
  );
}
