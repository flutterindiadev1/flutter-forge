/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'app_style.dart' as _i2;
import 'typography_feel.dart' as _i3;
import 'color_mode.dart' as _i4;
import 'layout_density.dart' as _i5;

abstract class AiDesignBrief implements _i1.SerializableModel {
  AiDesignBrief._({
    required this.prompt,
    required this.stylePreference,
    required this.style,
    required this.primaryColor,
    required this.typography,
    required this.colorMode,
    required this.density,
  });

  factory AiDesignBrief({
    required String prompt,
    required String stylePreference,
    required _i2.AppStyle style,
    required String primaryColor,
    required _i3.TypographyFeel typography,
    required _i4.ColorMode colorMode,
    required _i5.LayoutDensity density,
  }) = _AiDesignBriefImpl;

  factory AiDesignBrief.fromJson(Map<String, dynamic> jsonSerialization) {
    return AiDesignBrief(
      prompt: jsonSerialization['prompt'] as String,
      stylePreference: jsonSerialization['stylePreference'] as String,
      style: _i2.AppStyle.fromJson((jsonSerialization['style'] as String)),
      primaryColor: jsonSerialization['primaryColor'] as String,
      typography: _i3.TypographyFeel.fromJson(
        (jsonSerialization['typography'] as String),
      ),
      colorMode: _i4.ColorMode.fromJson(
        (jsonSerialization['colorMode'] as String),
      ),
      density: _i5.LayoutDensity.fromJson(
        (jsonSerialization['density'] as String),
      ),
    );
  }

  String prompt;

  String stylePreference;

  _i2.AppStyle style;

  String primaryColor;

  _i3.TypographyFeel typography;

  _i4.ColorMode colorMode;

  _i5.LayoutDensity density;

  /// Returns a shallow copy of this [AiDesignBrief]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AiDesignBrief copyWith({
    String? prompt,
    String? stylePreference,
    _i2.AppStyle? style,
    String? primaryColor,
    _i3.TypographyFeel? typography,
    _i4.ColorMode? colorMode,
    _i5.LayoutDensity? density,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AiDesignBrief',
      'prompt': prompt,
      'stylePreference': stylePreference,
      'style': style.toJson(),
      'primaryColor': primaryColor,
      'typography': typography.toJson(),
      'colorMode': colorMode.toJson(),
      'density': density.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AiDesignBriefImpl extends AiDesignBrief {
  _AiDesignBriefImpl({
    required String prompt,
    required String stylePreference,
    required _i2.AppStyle style,
    required String primaryColor,
    required _i3.TypographyFeel typography,
    required _i4.ColorMode colorMode,
    required _i5.LayoutDensity density,
  }) : super._(
         prompt: prompt,
         stylePreference: stylePreference,
         style: style,
         primaryColor: primaryColor,
         typography: typography,
         colorMode: colorMode,
         density: density,
       );

  /// Returns a shallow copy of this [AiDesignBrief]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AiDesignBrief copyWith({
    String? prompt,
    String? stylePreference,
    _i2.AppStyle? style,
    String? primaryColor,
    _i3.TypographyFeel? typography,
    _i4.ColorMode? colorMode,
    _i5.LayoutDensity? density,
  }) {
    return AiDesignBrief(
      prompt: prompt ?? this.prompt,
      stylePreference: stylePreference ?? this.stylePreference,
      style: style ?? this.style,
      primaryColor: primaryColor ?? this.primaryColor,
      typography: typography ?? this.typography,
      colorMode: colorMode ?? this.colorMode,
      density: density ?? this.density,
    );
  }
}
