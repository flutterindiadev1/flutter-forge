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

abstract class IntegrationConfig implements _i1.SerializableModel {
  IntegrationConfig._({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.firebaseAnalytics,
    required this.firebaseCrashlytics,
    required this.firebaseMessaging,
    required this.firebaseRemoteConfig,
    required this.firebaseStorage,
    required this.stripe,
    required this.revenueCat,
    required this.googlePay,
    required this.googleMaps,
    required this.mapbox,
    required this.googleSignIn,
    required this.appleSignIn,
    required this.facebookAuth,
    required this.sentry,
    required this.datadog,
    required this.postHog,
  });

  factory IntegrationConfig({
    required bool firebaseAuth,
    required bool firebaseFirestore,
    required bool firebaseAnalytics,
    required bool firebaseCrashlytics,
    required bool firebaseMessaging,
    required bool firebaseRemoteConfig,
    required bool firebaseStorage,
    required bool stripe,
    required bool revenueCat,
    required bool googlePay,
    required bool googleMaps,
    required bool mapbox,
    required bool googleSignIn,
    required bool appleSignIn,
    required bool facebookAuth,
    required bool sentry,
    required bool datadog,
    required bool postHog,
  }) = _IntegrationConfigImpl;

  factory IntegrationConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntegrationConfig(
      firebaseAuth: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['firebaseAuth'],
      ),
      firebaseFirestore: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['firebaseFirestore'],
      ),
      firebaseAnalytics: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['firebaseAnalytics'],
      ),
      firebaseCrashlytics: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['firebaseCrashlytics'],
      ),
      firebaseMessaging: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['firebaseMessaging'],
      ),
      firebaseRemoteConfig: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['firebaseRemoteConfig'],
      ),
      firebaseStorage: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['firebaseStorage'],
      ),
      stripe: _i1.BoolJsonExtension.fromJson(jsonSerialization['stripe']),
      revenueCat: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['revenueCat'],
      ),
      googlePay: _i1.BoolJsonExtension.fromJson(jsonSerialization['googlePay']),
      googleMaps: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['googleMaps'],
      ),
      mapbox: _i1.BoolJsonExtension.fromJson(jsonSerialization['mapbox']),
      googleSignIn: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['googleSignIn'],
      ),
      appleSignIn: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['appleSignIn'],
      ),
      facebookAuth: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['facebookAuth'],
      ),
      sentry: _i1.BoolJsonExtension.fromJson(jsonSerialization['sentry']),
      datadog: _i1.BoolJsonExtension.fromJson(jsonSerialization['datadog']),
      postHog: _i1.BoolJsonExtension.fromJson(jsonSerialization['postHog']),
    );
  }

  bool firebaseAuth;

  bool firebaseFirestore;

  bool firebaseAnalytics;

  bool firebaseCrashlytics;

  bool firebaseMessaging;

  bool firebaseRemoteConfig;

  bool firebaseStorage;

  bool stripe;

  bool revenueCat;

  bool googlePay;

  bool googleMaps;

  bool mapbox;

  bool googleSignIn;

  bool appleSignIn;

  bool facebookAuth;

  bool sentry;

  bool datadog;

  bool postHog;

  /// Returns a shallow copy of this [IntegrationConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntegrationConfig copyWith({
    bool? firebaseAuth,
    bool? firebaseFirestore,
    bool? firebaseAnalytics,
    bool? firebaseCrashlytics,
    bool? firebaseMessaging,
    bool? firebaseRemoteConfig,
    bool? firebaseStorage,
    bool? stripe,
    bool? revenueCat,
    bool? googlePay,
    bool? googleMaps,
    bool? mapbox,
    bool? googleSignIn,
    bool? appleSignIn,
    bool? facebookAuth,
    bool? sentry,
    bool? datadog,
    bool? postHog,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IntegrationConfig',
      'firebaseAuth': firebaseAuth,
      'firebaseFirestore': firebaseFirestore,
      'firebaseAnalytics': firebaseAnalytics,
      'firebaseCrashlytics': firebaseCrashlytics,
      'firebaseMessaging': firebaseMessaging,
      'firebaseRemoteConfig': firebaseRemoteConfig,
      'firebaseStorage': firebaseStorage,
      'stripe': stripe,
      'revenueCat': revenueCat,
      'googlePay': googlePay,
      'googleMaps': googleMaps,
      'mapbox': mapbox,
      'googleSignIn': googleSignIn,
      'appleSignIn': appleSignIn,
      'facebookAuth': facebookAuth,
      'sentry': sentry,
      'datadog': datadog,
      'postHog': postHog,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _IntegrationConfigImpl extends IntegrationConfig {
  _IntegrationConfigImpl({
    required bool firebaseAuth,
    required bool firebaseFirestore,
    required bool firebaseAnalytics,
    required bool firebaseCrashlytics,
    required bool firebaseMessaging,
    required bool firebaseRemoteConfig,
    required bool firebaseStorage,
    required bool stripe,
    required bool revenueCat,
    required bool googlePay,
    required bool googleMaps,
    required bool mapbox,
    required bool googleSignIn,
    required bool appleSignIn,
    required bool facebookAuth,
    required bool sentry,
    required bool datadog,
    required bool postHog,
  }) : super._(
         firebaseAuth: firebaseAuth,
         firebaseFirestore: firebaseFirestore,
         firebaseAnalytics: firebaseAnalytics,
         firebaseCrashlytics: firebaseCrashlytics,
         firebaseMessaging: firebaseMessaging,
         firebaseRemoteConfig: firebaseRemoteConfig,
         firebaseStorage: firebaseStorage,
         stripe: stripe,
         revenueCat: revenueCat,
         googlePay: googlePay,
         googleMaps: googleMaps,
         mapbox: mapbox,
         googleSignIn: googleSignIn,
         appleSignIn: appleSignIn,
         facebookAuth: facebookAuth,
         sentry: sentry,
         datadog: datadog,
         postHog: postHog,
       );

  /// Returns a shallow copy of this [IntegrationConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IntegrationConfig copyWith({
    bool? firebaseAuth,
    bool? firebaseFirestore,
    bool? firebaseAnalytics,
    bool? firebaseCrashlytics,
    bool? firebaseMessaging,
    bool? firebaseRemoteConfig,
    bool? firebaseStorage,
    bool? stripe,
    bool? revenueCat,
    bool? googlePay,
    bool? googleMaps,
    bool? mapbox,
    bool? googleSignIn,
    bool? appleSignIn,
    bool? facebookAuth,
    bool? sentry,
    bool? datadog,
    bool? postHog,
  }) {
    return IntegrationConfig(
      firebaseAuth: firebaseAuth ?? this.firebaseAuth,
      firebaseFirestore: firebaseFirestore ?? this.firebaseFirestore,
      firebaseAnalytics: firebaseAnalytics ?? this.firebaseAnalytics,
      firebaseCrashlytics: firebaseCrashlytics ?? this.firebaseCrashlytics,
      firebaseMessaging: firebaseMessaging ?? this.firebaseMessaging,
      firebaseRemoteConfig: firebaseRemoteConfig ?? this.firebaseRemoteConfig,
      firebaseStorage: firebaseStorage ?? this.firebaseStorage,
      stripe: stripe ?? this.stripe,
      revenueCat: revenueCat ?? this.revenueCat,
      googlePay: googlePay ?? this.googlePay,
      googleMaps: googleMaps ?? this.googleMaps,
      mapbox: mapbox ?? this.mapbox,
      googleSignIn: googleSignIn ?? this.googleSignIn,
      appleSignIn: appleSignIn ?? this.appleSignIn,
      facebookAuth: facebookAuth ?? this.facebookAuth,
      sentry: sentry ?? this.sentry,
      datadog: datadog ?? this.datadog,
      postHog: postHog ?? this.postHog,
    );
  }
}
