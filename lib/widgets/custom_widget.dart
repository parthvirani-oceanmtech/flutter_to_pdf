import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

Widget linkWidget({required String linkText, required Widget child}) {
  return Column(
    children: [
      Visibility(visible: false, child: Text(linkText)),
      child,
    ],
  );
}
