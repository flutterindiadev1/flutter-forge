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

import 'package:serverpod/serverpod.dart' as _i1;
import 'monetization_model.dart' as _i2;
import 'subscription_provider.dart' as _i3;
import 'package:flutterforge_backend_server/src/generated/protocol.dart' as _i4;

abstract class MonetizationConfig
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  MonetizationConfig._({
    required this.model,
    this.provider,
    required this.plans,
  });

  factory MonetizationConfig({
    required _i2.MonetizationModel model,
    _i3.SubscriptionProvider? provider,
    required List<String> plans,
  }) = _MonetizationConfigImpl;

  factory MonetizationConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return MonetizationConfig(
      model: _i2.MonetizationModel.fromJson(
        (jsonSerialization['model'] as String),
      ),
      provider: jsonSerialization['provider'] == null
          ? null
          : _i3.SubscriptionProvider.fromJson(
              (jsonSerialization['provider'] as String),
            ),
      plans: _i4.Protocol().deserialize<List<String>>(
        jsonSerialization['plans'],
      ),
    );
  }

  _i2.MonetizationModel model;

  _i3.SubscriptionProvider? provider;

  List<String> plans;

  /// Returns a shallow copy of this [MonetizationConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MonetizationConfig copyWith({
    _i2.MonetizationModel? model,
    _i3.SubscriptionProvider? provider,
    List<String>? plans,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MonetizationConfig',
      'model': model.toJson(),
      if (provider != null) 'provider': provider?.toJson(),
      'plans': plans.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MonetizationConfig',
      'model': model.toJson(),
      if (provider != null) 'provider': provider?.toJson(),
      'plans': plans.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MonetizationConfigImpl extends MonetizationConfig {
  _MonetizationConfigImpl({
    required _i2.MonetizationModel model,
    _i3.SubscriptionProvider? provider,
    required List<String> plans,
  }) : super._(
         model: model,
         provider: provider,
         plans: plans,
       );

  /// Returns a shallow copy of this [MonetizationConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MonetizationConfig copyWith({
    _i2.MonetizationModel? model,
    Object? provider = _Undefined,
    List<String>? plans,
  }) {
    return MonetizationConfig(
      model: model ?? this.model,
      provider: provider is _i3.SubscriptionProvider?
          ? provider
          : this.provider,
      plans: plans ?? this.plans.map((e0) => e0).toList(),
    );
  }
}
