import 'package:flutter/widgets.dart' show SizedBox;

import 'package:pdf/widgets.dart' as pw show SizedBox, UrlLink, Widget;

/// Extension on [SizedBox] to convert it to the pdf equivalent [pw.SizedBox].
extension SizedBoxConverter on SizedBox {
  /// Converts the [SizedBox] to a [pw.SizedBox].
  pw.Widget toPdfWidget(pw.Widget? child, {required String linkData}) => linkData.isEmpty
      ? pw.SizedBox(
          width: width,
          height: height,
          child: child,
        )
      : pw.UrlLink(
          child: pw.SizedBox(
            width: width,
            height: height,
            child: child,
          ),
          destination: linkData,
        );
}
