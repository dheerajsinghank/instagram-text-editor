import 'package:flutter/material.dart';
import 'package:text_editor/src/text_style_model.dart';
import 'package:text_editor/text_editor_data.dart';

class TextBackgroundColor extends StatelessWidget {
  const TextBackgroundColor({
    this.enableWidget,
    this.disableWidget,
    Key? key,
  }) : super(key: key);

  final Widget? enableWidget;
  final Widget? disableWidget;

  @override
  Widget build(BuildContext context) {
    final model = TextEditorData.of(context).textStyleModel;
    return GestureDetector(
      onTap: () => model.changeTextBackground(),
      child: model.textBackgroundStatus != TextBackgroundStatus.disable
          ? enableWidget ??
              _SwitchButton(iconData: Icons.format_color_fill, enabled: true)
          : disableWidget ??
              _SwitchButton(iconData: Icons.format_color_fill, enabled: false),
    );
  }
}

enum FormatStyle {
  bold,
  italic,
}

class FormatStyleWidget extends StatelessWidget {
  const FormatStyleWidget({
    required this.formatStyle,
    Key? key,
  }) : super(key: key);

  final FormatStyle formatStyle;

  @override
  Widget build(BuildContext context) {
    final model = TextEditorData.of(context).textStyleModel;

    final bool enabled;

    if (formatStyle == FormatStyle.bold) {
      final fontWeight = model.textStyle?.fontWeight;
      enabled = fontWeight == FontWeight.w700 ||
          fontWeight == FontWeight.w800 ||
          fontWeight == FontWeight.w900;
    } else {
      enabled = model.textStyle?.fontStyle == FontStyle.italic;
    }

    return GestureDetector(
      onTap: () {},
      child: _SwitchButton(
        iconData: formatStyle == FormatStyle.bold
            ? Icons.format_bold
            : Icons.format_italic,
        enabled: enabled,
      ),
    );
  }
}

class _SwitchButton extends StatelessWidget {
  const _SwitchButton({
    required this.iconData,
    this.enabled = false,
    Key? key,
  }) : super(key: key);

  final IconData iconData;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: !enabled ? null : Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Icon(
        iconData,
        size: 20,
        color: !enabled ? Colors.white : Colors.black,
      ),
    );
  }
}
