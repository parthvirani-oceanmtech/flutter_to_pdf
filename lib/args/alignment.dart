import 'package:flutter/widgets.dart' show Alignment;

import 'package:pdf/widgets.dart' as pw show Alignment;

extension AlignmentConverter on Alignment {
  pw.Alignment toPdfAlignment() => pw.Alignment(x, y);
}

// extension AlignmentDirectionalConverter on AlignmentDirectional {
//   pw.AlignmentDirectional toPdfAlignmentDirectional() => pw.AlignmentDirectional(start, y);
// }
