import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/widgets/colors.dart';

/// [TextStyle] for headers of cards.
TextStyle get headerTextStyle => TextStyle(fontSize: 20.0, color: titleColor);

/// [TextStyle] for medium size texts.
TextStyle get mediumTextStyle => TextStyle(fontSize: 16.0);

/// Similar to [headerTextStyle], but used when the header value is editable.
TextStyle get editableHeaderStyle => headerTextStyle.copyWith(
    decoration: TextDecoration.underline,
    decorationStyle: TextDecorationStyle.dashed,
    decorationColor: underlineColor);

/// Similar to [mediumTextStyle], but used when the text is editable.
TextStyle get editableMediumTextStyle => mediumTextStyle.copyWith(
    decoration: TextDecoration.underline,
    decorationStyle: TextDecorationStyle.dashed,
    decorationColor: underlineColor);
