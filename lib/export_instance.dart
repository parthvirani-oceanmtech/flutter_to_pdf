import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'export_delegate.dart';
import 'utils.dart';
import 'widgets/container.dart';
import 'widgets/center.dart';
import 'widgets/sized_box.dart';
import 'widgets/fitted_box.dart';
import 'widgets/limited_box.dart';
import 'widgets/constrained_box.dart';
import 'widgets/clip.dart';
import 'widgets/transform.dart';
import 'widgets/opacity.dart';
import 'widgets/padding.dart';
import 'widgets/align.dart';
import 'widgets/positioned.dart';
import 'widgets/expanded.dart';
import 'widgets/flexible.dart';
import 'widgets/placeholder.dart';
import 'widgets/text.dart';
import 'widgets/text_field.dart';
import 'widgets/divider.dart';
import 'widgets/image.dart';
import 'widgets/checkbox.dart';
import 'widgets/button.dart';
import 'widgets/column.dart';
import 'widgets/row.dart';
import 'widgets/stack.dart';
import 'widgets/list_view.dart';
import 'widgets/grid_view.dart';
import 'widgets/wrap.dart';
import 'widgets/table.dart';

String linkURL = '';

/// The delegate handling the low-level export of the widget tree.
class ExportInstance {
  /// The delegate that is used to export the widget.
  final ExportDelegate delegate;

  /// The function to export a [Widget] to a [pw.Widget].
  final Future<pw.Widget> Function(Widget widget) exportFunc;

  const ExportInstance(this.delegate, this.exportFunc);

  /// Recursive helper to visit all child elements of the provided [element].
  Future<List<pw.Widget>> _visit(Element element, BuildContext? context) async {
    List<Element> elements = [];

    element.visitChildElements((Element element) async => elements.add(element));

    List<pw.Widget> children = [];
    for (Element e in elements) {
      children.addAll(await matchWidget(e, context));
    }

    return children;
  }

  /// Matches the widget provided as [element]
  /// and returns the corresponding [pw.Widget].
  /// The [context] is only null when called from [exportFunc].
  Future<List<pw.Widget>> matchWidget(Element element, BuildContext? context) async {
    final Widget widget = element.widget;

    switch (widget.runtimeType) {
      case MergeSemantics: //anchor: end of widget tree
        return [];
      case Container:
        final List children = await _visit(element, context);
        return [
          await (widget as Container).toPdfWidget(children.isNotEmpty ? children.first : null, linkText: linkURL)
        ];
      case Center:
        final List children = await _visit(element, context);
        return [(widget as Center).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case SizedBox:
        final List children = await _visit(element, context);
        return [(widget as SizedBox).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case FittedBox:
        final List children = await _visit(element, context);
        return [(widget as FittedBox).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case LimitedBox:
        final List children = await _visit(element, context);
        return [(widget as LimitedBox).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case ConstrainedBox:
        final List children = await _visit(element, context);
        return [(widget as ConstrainedBox).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case ClipRect:
        final List children = await _visit(element, context);
        return [(widget as ClipRect).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case ClipRRect:
        final List children = await _visit(element, context);
        return [(widget as ClipRRect).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case ClipOval:
        final List children = await _visit(element, context);
        return [(widget as ClipOval).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case Transform:
        final List children = await _visit(element, context);
        return [(widget as Transform).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case Opacity:
        final List children = await _visit(element, context);
        return [(widget as Opacity).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case Padding:
        final List children = await _visit(element, context);
        return [(widget as Padding).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case Align:
        final List children = await _visit(element, context);
        return [(widget as Align).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case InkWell:
        final List children = await _visit(element, context);
        return [(widget as Align).toPdfWidget(children.isNotEmpty ? children.first : null)];
      case Positioned:
        final List children = await _visit(element, context);
        return [
          (widget as Positioned).toPdfWidget(
            children.isNotEmpty ? children.first : pw.Container(),
          )
        ];
      case Expanded:
        final List children = await _visit(element, context);
        return [
          (widget as Expanded).toPdfWidget(
            children.isNotEmpty ? children.first : pw.Container(),
          )
        ];
      case Flexible:
        final List children = await _visit(element, context);
        return [
          (widget as Flexible).toPdfWidget(
            children.isNotEmpty ? children.first : pw.Container(),
          )
        ];
      case Placeholder:
        return [(widget as Placeholder).toPdfWidget()];
      case Text:
        return [await (widget as Text).toPdfWidget(this)];
      case TextField:
        TextField? contextWidget;
        if (context != null) {
          TextFormField? textFormField;
          if (widget.key == null) {
            textFormField = element.findAncestorWidgetOfExactType<TextFormField>();
            if (textFormField?.key == null) {
              throw Exception('TextField must have a key to be exported');
            }
          }

          if (textFormField == null) {
            Element? contextElement = findElement(context, (TextField e) => e.key == widget.key);
            contextWidget = contextElement!.widget as TextField;
          } else {
            Element? contextElement = findElement(context, (TextFormField e) => e.key == textFormField!.key);
            contextElement = findFirstDescendantElement<TextField>(contextElement!);
            contextWidget = contextElement!.widget as TextField;
          }
        }
        return [await (widget as TextField).toPdfWidget(this, contextWidget)];
      case Divider:
        return [(widget as Divider).toPdfWidget()];
      case Image:
        return [await (widget as Image).toPdfWidget()];
      case Checkbox:
        Checkbox? contextWidget;
        if (context != null) {
          if (widget.key == null) {
            throw Exception('Checkbox must have a key to be exported');
          }
          Element? contextElement = findElement(context, (Checkbox e) => e.key == widget.key);
          contextWidget = contextElement!.widget as Checkbox;
        }
        return [await (widget as Checkbox).toPdfWidget(delegate.options.checkboxOptions, contextWidget)];
      case TextButton:
      case ElevatedButton:
      case OutlinedButton:
      case FilledButton:
        return [(widget as ButtonStyleButton).toPdfWidget((await _visit(element, context)).first)];
      case Column:
        var children = (widget as Column).children;
        if (children.length == 2) {
          Text? textWidget;
          Widget? secondWidget;

          if ((children.first.runtimeType is Visibility) &&
              (children.first.runtimeType as Visibility).visible == false &&
              (children.first.runtimeType as Visibility).child.runtimeType is Text) {
            textWidget = children.first as Text;

            secondWidget = children.last;
          } else if ((children.last.runtimeType is Visibility) &&
              (children.last.runtimeType as Visibility).visible == false &&
              (children.last.runtimeType as Visibility).child.runtimeType is Text) {
            textWidget = children.last as Text;
            secondWidget = children.first;
          }

          if (textWidget?.data?.isEmpty ?? true) {
            textWidget = null;
          }

          if (textWidget != null && secondWidget != null) {
            linkURL = textWidget.data!;
            List<pw.Widget> allWidget = await _visit(element, context);
            linkURL = '';
            return [widget.toPdfWidget(allWidget)];
          } else {
            return [widget.toPdfWidget(await _visit(element, context))];
          }
        } else {
          return [widget.toPdfWidget(await _visit(element, context))];
        }

      case Row:
        return [(widget as Row).toPdfWidget(await _visit(element, context))];
      case Stack:
        return [(widget as Stack).toPdfWidget(await _visit(element, context))];
      case ListView:
        return [(widget as ListView).toPdfWidget(await _visit(element, context))];
      case GridView:
        final constraints = BoxConstraints(
          maxWidth: element.renderObject!.paintBounds.right,
          maxHeight: element.renderObject!.paintBounds.bottom,
        );
        return [(widget as GridView).toPdfWidget(await _visit(element, context), constraints)];
      case Wrap:
        return [(widget as Wrap).toPdfWidget(await _visit(element, context))];
      case Table:
        return [await (widget as Table).toPdfWidget(await _visit(element, context))];
      default:
        return await _visit(element, context);
    }
  }
}
