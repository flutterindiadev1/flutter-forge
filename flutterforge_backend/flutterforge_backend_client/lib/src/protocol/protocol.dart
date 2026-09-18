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
import 'architecture_config.dart' as _i3;
import 'asset_file.dart' as _i4;
import 'ci_cd_config.dart' as _i5;
import 'cicd_platform.dart' as _i6;
import 'color_mode.dart' as _i7;
import 'custom_painter_spec.dart' as _i8;
import 'environment_config.dart' as _i9;
import 'feature_layer.dart' as _i10;
import 'feature_node.dart' as _i11;
import 'figma_config.dart' as _i12;
import 'greetings/greeting.dart' as _i13;
import 'integration_config.dart' as _i14;
import 'layout_density.dart' as _i15;
import 'localization_config.dart' as _i16;
import 'monetization_config.dart' as _i17;
import 'monetization_model.dart' as _i18;
import 'native_module_spec.dart' as _i19;
import 'pipeline_command.dart' as _i20;
import 'pipeline_event.dart' as _i21;
import 'pipeline_phase.dart' as _i22;
import 'pipeline_state_message.dart' as _i23;
import 'project_config.dart' as _i24;
import 'project_record.dart' as _i25;
import 'pub_dependency.dart' as _i26;
import 'subscription_provider.dart' as _i27;
import 'testing_config.dart' as _i28;
import 'typography_feel.dart' as _i29;
import 'user_settings.dart' as _i30;
import 'package:flutterforge_backend_client/src/protocol/project_record.dart'
    as _i31;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i32;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i33;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i34;
export 'app_style.dart';
export 'architecture_config.dart';
export 'asset_file.dart';
export 'ci_cd_config.dart';
export 'cicd_platform.dart';
export 'color_mode.dart';
export 'custom_painter_spec.dart';
export 'environment_config.dart';
export 'feature_layer.dart';
export 'feature_node.dart';
export 'figma_config.dart';
export 'greetings/greeting.dart';
export 'integration_config.dart';
export 'layout_density.dart';
export 'localization_config.dart';
export 'monetization_config.dart';
export 'monetization_model.dart';
export 'native_module_spec.dart';
export 'pipeline_command.dart';
export 'pipeline_event.dart';
export 'pipeline_phase.dart';
export 'pipeline_state_message.dart';
export 'project_config.dart';
export 'project_record.dart';
export 'pub_dependency.dart';
export 'subscription_provider.dart';
export 'testing_config.dart';
export 'typography_feel.dart';
export 'user_settings.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AppStyle) {
      return _i2.AppStyle.fromJson(data) as T;
    }
    if (t == _i3.ArchitectureConfig) {
      return _i3.ArchitectureConfig.fromJson(data) as T;
    }
    if (t == _i4.AssetFile) {
      return _i4.AssetFile.fromJson(data) as T;
    }
    if (t == _i5.CiCdConfig) {
      return _i5.CiCdConfig.fromJson(data) as T;
    }
    if (t == _i6.CiCdPlatform) {
      return _i6.CiCdPlatform.fromJson(data) as T;
    }
    if (t == _i7.ColorMode) {
      return _i7.ColorMode.fromJson(data) as T;
    }
    if (t == _i8.CustomPainterSpec) {
      return _i8.CustomPainterSpec.fromJson(data) as T;
    }
    if (t == _i9.EnvironmentConfig) {
      return _i9.EnvironmentConfig.fromJson(data) as T;
    }
    if (t == _i10.FeatureLayer) {
      return _i10.FeatureLayer.fromJson(data) as T;
    }
    if (t == _i11.FeatureNode) {
      return _i11.FeatureNode.fromJson(data) as T;
    }
    if (t == _i12.FigmaConfig) {
      return _i12.FigmaConfig.fromJson(data) as T;
    }
    if (t == _i13.Greeting) {
      return _i13.Greeting.fromJson(data) as T;
    }
    if (t == _i14.IntegrationConfig) {
      return _i14.IntegrationConfig.fromJson(data) as T;
    }
    if (t == _i15.LayoutDensity) {
      return _i15.LayoutDensity.fromJson(data) as T;
    }
    if (t == _i16.LocalizationConfig) {
      return _i16.LocalizationConfig.fromJson(data) as T;
    }
    if (t == _i17.MonetizationConfig) {
      return _i17.MonetizationConfig.fromJson(data) as T;
    }
    if (t == _i18.MonetizationModel) {
      return _i18.MonetizationModel.fromJson(data) as T;
    }
    if (t == _i19.NativeModuleSpec) {
      return _i19.NativeModuleSpec.fromJson(data) as T;
    }
    if (t == _i20.PipelineCommand) {
      return _i20.PipelineCommand.fromJson(data) as T;
    }
    if (t == _i21.PipelineEvent) {
      return _i21.PipelineEvent.fromJson(data) as T;
    }
    if (t == _i22.PipelinePhase) {
      return _i22.PipelinePhase.fromJson(data) as T;
    }
    if (t == _i23.PipelineStateMessage) {
      return _i23.PipelineStateMessage.fromJson(data) as T;
    }
    if (t == _i24.ProjectConfig) {
      return _i24.ProjectConfig.fromJson(data) as T;
    }
    if (t == _i25.ProjectRecord) {
      return _i25.ProjectRecord.fromJson(data) as T;
    }
    if (t == _i26.PubDependency) {
      return _i26.PubDependency.fromJson(data) as T;
    }
    if (t == _i27.SubscriptionProvider) {
      return _i27.SubscriptionProvider.fromJson(data) as T;
    }
    if (t == _i28.TestingConfig) {
      return _i28.TestingConfig.fromJson(data) as T;
    }
    if (t == _i29.TypographyFeel) {
      return _i29.TypographyFeel.fromJson(data) as T;
    }
    if (t == _i30.UserSettings) {
      return _i30.UserSettings.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AppStyle?>()) {
      return (data != null ? _i2.AppStyle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ArchitectureConfig?>()) {
      return (data != null ? _i3.ArchitectureConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AssetFile?>()) {
      return (data != null ? _i4.AssetFile.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.CiCdConfig?>()) {
      return (data != null ? _i5.CiCdConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CiCdPlatform?>()) {
      return (data != null ? _i6.CiCdPlatform.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ColorMode?>()) {
      return (data != null ? _i7.ColorMode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.CustomPainterSpec?>()) {
      return (data != null ? _i8.CustomPainterSpec.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.EnvironmentConfig?>()) {
      return (data != null ? _i9.EnvironmentConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.FeatureLayer?>()) {
      return (data != null ? _i10.FeatureLayer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.FeatureNode?>()) {
      return (data != null ? _i11.FeatureNode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.FigmaConfig?>()) {
      return (data != null ? _i12.FigmaConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Greeting?>()) {
      return (data != null ? _i13.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.IntegrationConfig?>()) {
      return (data != null ? _i14.IntegrationConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.LayoutDensity?>()) {
      return (data != null ? _i15.LayoutDensity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.LocalizationConfig?>()) {
      return (data != null ? _i16.LocalizationConfig.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.MonetizationConfig?>()) {
      return (data != null ? _i17.MonetizationConfig.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.MonetizationModel?>()) {
      return (data != null ? _i18.MonetizationModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.NativeModuleSpec?>()) {
      return (data != null ? _i19.NativeModuleSpec.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.PipelineCommand?>()) {
      return (data != null ? _i20.PipelineCommand.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.PipelineEvent?>()) {
      return (data != null ? _i21.PipelineEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.PipelinePhase?>()) {
      return (data != null ? _i22.PipelinePhase.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.PipelineStateMessage?>()) {
      return (data != null ? _i23.PipelineStateMessage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.ProjectConfig?>()) {
      return (data != null ? _i24.ProjectConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ProjectRecord?>()) {
      return (data != null ? _i25.ProjectRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.PubDependency?>()) {
      return (data != null ? _i26.PubDependency.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.SubscriptionProvider?>()) {
      return (data != null ? _i27.SubscriptionProvider.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.TestingConfig?>()) {
      return (data != null ? _i28.TestingConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.TypographyFeel?>()) {
      return (data != null ? _i29.TypographyFeel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.UserSettings?>()) {
      return (data != null ? _i30.UserSettings.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i21.PipelineEvent>) {
      return (data as List)
              .map((e) => deserialize<_i21.PipelineEvent>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i11.FeatureNode>) {
      return (data as List)
              .map((e) => deserialize<_i11.FeatureNode>(e))
              .toList()
          as T;
    }
    if (t == List<_i8.CustomPainterSpec>) {
      return (data as List)
              .map((e) => deserialize<_i8.CustomPainterSpec>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.NativeModuleSpec>) {
      return (data as List)
              .map((e) => deserialize<_i19.NativeModuleSpec>(e))
              .toList()
          as T;
    }
    if (t == List<_i26.PubDependency>) {
      return (data as List)
              .map((e) => deserialize<_i26.PubDependency>(e))
              .toList()
          as T;
    }
    if (t == List<_i4.AssetFile>) {
      return (data as List).map((e) => deserialize<_i4.AssetFile>(e)).toList()
          as T;
    }
    if (t == List<_i31.ProjectRecord>) {
      return (data as List)
              .map((e) => deserialize<_i31.ProjectRecord>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i32.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i33.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i34.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AppStyle => 'AppStyle',
      _i3.ArchitectureConfig => 'ArchitectureConfig',
      _i4.AssetFile => 'AssetFile',
      _i5.CiCdConfig => 'CiCdConfig',
      _i6.CiCdPlatform => 'CiCdPlatform',
      _i7.ColorMode => 'ColorMode',
      _i8.CustomPainterSpec => 'CustomPainterSpec',
      _i9.EnvironmentConfig => 'EnvironmentConfig',
      _i10.FeatureLayer => 'FeatureLayer',
      _i11.FeatureNode => 'FeatureNode',
      _i12.FigmaConfig => 'FigmaConfig',
      _i13.Greeting => 'Greeting',
      _i14.IntegrationConfig => 'IntegrationConfig',
      _i15.LayoutDensity => 'LayoutDensity',
      _i16.LocalizationConfig => 'LocalizationConfig',
      _i17.MonetizationConfig => 'MonetizationConfig',
      _i18.MonetizationModel => 'MonetizationModel',
      _i19.NativeModuleSpec => 'NativeModuleSpec',
      _i20.PipelineCommand => 'PipelineCommand',
      _i21.PipelineEvent => 'PipelineEvent',
      _i22.PipelinePhase => 'PipelinePhase',
      _i23.PipelineStateMessage => 'PipelineStateMessage',
      _i24.ProjectConfig => 'ProjectConfig',
      _i25.ProjectRecord => 'ProjectRecord',
      _i26.PubDependency => 'PubDependency',
      _i27.SubscriptionProvider => 'SubscriptionProvider',
      _i28.TestingConfig => 'TestingConfig',
      _i29.TypographyFeel => 'TypographyFeel',
      _i30.UserSettings => 'UserSettings',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'flutterforge_backend.',
        '',
      );
    }

    switch (data) {
      case _i2.AppStyle():
        return 'AppStyle';
      case _i3.ArchitectureConfig():
        return 'ArchitectureConfig';
      case _i4.AssetFile():
        return 'AssetFile';
      case _i5.CiCdConfig():
        return 'CiCdConfig';
      case _i6.CiCdPlatform():
        return 'CiCdPlatform';
      case _i7.ColorMode():
        return 'ColorMode';
      case _i8.CustomPainterSpec():
        return 'CustomPainterSpec';
      case _i9.EnvironmentConfig():
        return 'EnvironmentConfig';
      case _i10.FeatureLayer():
        return 'FeatureLayer';
      case _i11.FeatureNode():
        return 'FeatureNode';
      case _i12.FigmaConfig():
        return 'FigmaConfig';
      case _i13.Greeting():
        return 'Greeting';
      case _i14.IntegrationConfig():
        return 'IntegrationConfig';
      case _i15.LayoutDensity():
        return 'LayoutDensity';
      case _i16.LocalizationConfig():
        return 'LocalizationConfig';
      case _i17.MonetizationConfig():
        return 'MonetizationConfig';
      case _i18.MonetizationModel():
        return 'MonetizationModel';
      case _i19.NativeModuleSpec():
        return 'NativeModuleSpec';
      case _i20.PipelineCommand():
        return 'PipelineCommand';
      case _i21.PipelineEvent():
        return 'PipelineEvent';
      case _i22.PipelinePhase():
        return 'PipelinePhase';
      case _i23.PipelineStateMessage():
        return 'PipelineStateMessage';
      case _i24.ProjectConfig():
        return 'ProjectConfig';
      case _i25.ProjectRecord():
        return 'ProjectRecord';
      case _i26.PubDependency():
        return 'PubDependency';
      case _i27.SubscriptionProvider():
        return 'SubscriptionProvider';
      case _i28.TestingConfig():
        return 'TestingConfig';
      case _i29.TypographyFeel():
        return 'TypographyFeel';
      case _i30.UserSettings():
        return 'UserSettings';
    }
    className = _i32.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i33.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i34.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AppStyle') {
      return deserialize<_i2.AppStyle>(data['data']);
    }
    if (dataClassName == 'ArchitectureConfig') {
      return deserialize<_i3.ArchitectureConfig>(data['data']);
    }
    if (dataClassName == 'AssetFile') {
      return deserialize<_i4.AssetFile>(data['data']);
    }
    if (dataClassName == 'CiCdConfig') {
      return deserialize<_i5.CiCdConfig>(data['data']);
    }
    if (dataClassName == 'CiCdPlatform') {
      return deserialize<_i6.CiCdPlatform>(data['data']);
    }
    if (dataClassName == 'ColorMode') {
      return deserialize<_i7.ColorMode>(data['data']);
    }
    if (dataClassName == 'CustomPainterSpec') {
      return deserialize<_i8.CustomPainterSpec>(data['data']);
    }
    if (dataClassName == 'EnvironmentConfig') {
      return deserialize<_i9.EnvironmentConfig>(data['data']);
    }
    if (dataClassName == 'FeatureLayer') {
      return deserialize<_i10.FeatureLayer>(data['data']);
    }
    if (dataClassName == 'FeatureNode') {
      return deserialize<_i11.FeatureNode>(data['data']);
    }
    if (dataClassName == 'FigmaConfig') {
      return deserialize<_i12.FigmaConfig>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i13.Greeting>(data['data']);
    }
    if (dataClassName == 'IntegrationConfig') {
      return deserialize<_i14.IntegrationConfig>(data['data']);
    }
    if (dataClassName == 'LayoutDensity') {
      return deserialize<_i15.LayoutDensity>(data['data']);
    }
    if (dataClassName == 'LocalizationConfig') {
      return deserialize<_i16.LocalizationConfig>(data['data']);
    }
    if (dataClassName == 'MonetizationConfig') {
      return deserialize<_i17.MonetizationConfig>(data['data']);
    }
    if (dataClassName == 'MonetizationModel') {
      return deserialize<_i18.MonetizationModel>(data['data']);
    }
    if (dataClassName == 'NativeModuleSpec') {
      return deserialize<_i19.NativeModuleSpec>(data['data']);
    }
    if (dataClassName == 'PipelineCommand') {
      return deserialize<_i20.PipelineCommand>(data['data']);
    }
    if (dataClassName == 'PipelineEvent') {
      return deserialize<_i21.PipelineEvent>(data['data']);
    }
    if (dataClassName == 'PipelinePhase') {
      return deserialize<_i22.PipelinePhase>(data['data']);
    }
    if (dataClassName == 'PipelineStateMessage') {
      return deserialize<_i23.PipelineStateMessage>(data['data']);
    }
    if (dataClassName == 'ProjectConfig') {
      return deserialize<_i24.ProjectConfig>(data['data']);
    }
    if (dataClassName == 'ProjectRecord') {
      return deserialize<_i25.ProjectRecord>(data['data']);
    }
    if (dataClassName == 'PubDependency') {
      return deserialize<_i26.PubDependency>(data['data']);
    }
    if (dataClassName == 'SubscriptionProvider') {
      return deserialize<_i27.SubscriptionProvider>(data['data']);
    }
    if (dataClassName == 'TestingConfig') {
      return deserialize<_i28.TestingConfig>(data['data']);
    }
    if (dataClassName == 'TypographyFeel') {
      return deserialize<_i29.TypographyFeel>(data['data']);
    }
    if (dataClassName == 'UserSettings') {
      return deserialize<_i30.UserSettings>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i32.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i33.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i34.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i32.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i33.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i34.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
