import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum TextBackgroundStatus { enable, exchange, disable }

class TextStyleModel extends ChangeNotifier {
  String text;
  String? fontFamily;
  TextStyle? textStyle;
  TextAlign? textAlign;
  late TextBackgroundStatus textBackgroundStatus;

  TextStyleModel(
    this.text, {
    this.fontFamily,
    this.textAlign,
    this.textStyle,
  }) {
    textStyle = textStyle ?? TextStyle(fontSize: 10);
    textAlign = textAlign ?? TextAlign.center;

    textBackgroundStatus = textStyle!.backgroundColor == null ||
            textStyle!.backgroundColor == Colors.transparent
        ? TextBackgroundStatus.disable
        : TextBackgroundStatus.enable;
  }

  void editTextAlinment(TextAlign value) {
    this.textAlign = value;

    notifyListeners();
  }

  void editTextColor(Color value, {bool changeBackground = false}) {
    if (textBackgroundStatus == TextBackgroundStatus.disable) {
      this.textStyle = this
          .textStyle!
          .copyWith(color: value, backgroundColor: Colors.transparent);
    } else if (textBackgroundStatus == TextBackgroundStatus.enable) {
      this.textStyle = this
          .textStyle!
          .copyWith(color: _adjustColor(value), backgroundColor: value);
    } else {
      if (changeBackground) {
        // Exchange color and background if background status is changing
        this.textStyle = this.textStyle!.copyWith(
            color: textStyle!.backgroundColor,
            backgroundColor: textStyle!.color);
      } else {
        this.textStyle = this
            .textStyle!
            .copyWith(color: value, backgroundColor: _adjustColor(value));
      }
    }

    notifyListeners();
  }

  void editFontSize(double value) {
    this.textStyle = this.textStyle!.copyWith(fontSize: value);

    notifyListeners();
  }

  void changeFontFamily(String value) {
    fontFamily = value;

    this.textStyle = GoogleFonts.getFont(value, textStyle: textStyle!);

    notifyListeners();
  }

  void changeFontStyle(FontStyle value) {
    if (fontFamily == null) {
      this.textStyle = textStyle?.copyWith(
        fontStyle: value,
      );
    } else {
      this.textStyle = GoogleFonts.getFont(
        fontFamily!,
        textStyle: textStyle?.copyWith(
          fontStyle: value,
        ),
      );
    }

    notifyListeners();
  }

  void changeFontWeight(FontWeight value) {
    if (fontFamily == null) {
      this.textStyle = textStyle?.copyWith(
        fontWeight: value,
      );
    } else {
      this.textStyle = GoogleFonts.getFont(
        fontFamily!,
        textStyle: textStyle?.copyWith(
          fontWeight: value,
        ),
      );
    }

    notifyListeners();
  }

  void changeTextBackground() {
    switch (textBackgroundStatus) {
      case TextBackgroundStatus.disable:
        textBackgroundStatus = TextBackgroundStatus.enable;
        break;
      case TextBackgroundStatus.enable:
        textBackgroundStatus = TextBackgroundStatus.exchange;
        break;
      default:
        textBackgroundStatus = TextBackgroundStatus.disable;
    }

    editTextColor(textStyle!.color ?? Colors.black, changeBackground: true);
  }

  Color _adjustColor(Color? color, [double amount = 0.3]) {
    assert(amount >= 0 && amount <= 1);

    if (color == Colors.black) {
      return Colors.white;
    } else if (color == Colors.white) {
      return Colors.black;
    }

    final hsl = HSLColor.fromColor(color!);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
