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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i4;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i5;
import 'ai_analysis_result.dart' as _i6;
import 'ai_design_brief.dart' as _i7;
import 'app_style.dart' as _i8;
import 'architecture_config.dart' as _i9;
import 'asset_file.dart' as _i10;
import 'ci_cd_config.dart' as _i11;
import 'cicd_platform.dart' as _i12;
import 'color_mode.dart' as _i13;
import 'custom_painter_spec.dart' as _i14;
import 'design_source.dart' as _i15;
import 'environment_config.dart' as _i16;
import 'feature_layer.dart' as _i17;
import 'feature_node.dart' as _i18;
import 'figma_config.dart' as _i19;
import 'greetings/greeting.dart' as _i20;
import 'integration_config.dart' as _i21;
import 'layout_density.dart' as _i22;
import 'llm_instruction.dart' as _i23;
import 'localization_config.dart' as _i24;
import 'monetization_config.dart' as _i25;
import 'monetization_model.dart' as _i26;
import 'native_module_spec.dart' as _i27;
import 'pipeline_command.dart' as _i28;
import 'pipeline_event.dart' as _i29;
import 'pipeline_phase.dart' as _i30;
import 'pipeline_state_message.dart' as _i31;
import 'postman_config.dart' as _i32;
import 'project_config.dart' as _i33;
import 'project_record.dart' as _i34;
import 'pub_dependency.dart' as _i35;
import 'subscription_provider.dart' as _i36;
import 'testing_config.dart' as _i37;
import 'typography_feel.dart' as _i38;
import 'user_persona.dart' as _i39;
import 'user_persona_type.dart' as _i40;
import 'user_settings.dart' as _i41;
import 'package:flutterforge_backend_server/src/generated/project_record.dart'
    as _i42;
export 'ai_analysis_result.dart';
export 'ai_design_brief.dart';
export 'app_style.dart';
export 'architecture_config.dart';
export 'asset_file.dart';
export 'ci_cd_config.dart';
export 'cicd_platform.dart';
export 'color_mode.dart';
export 'custom_painter_spec.dart';
export 'design_source.dart';
export 'environment_config.dart';
export 'feature_layer.dart';
export 'feature_node.dart';
export 'figma_config.dart';
export 'greetings/greeting.dart';
export 'integration_config.dart';
export 'layout_density.dart';
export 'llm_instruction.dart';
export 'localization_config.dart';
export 'monetization_config.dart';
export 'monetization_model.dart';
export 'native_module_spec.dart';
export 'pipeline_command.dart';
export 'pipeline_event.dart';
export 'pipeline_phase.dart';
export 'pipeline_state_message.dart';
export 'postman_config.dart';
export 'project_config.dart';
export 'project_record.dart';
export 'pub_dependency.dart';
export 'subscription_provider.dart';
export 'testing_config.dart';
export 'typography_feel.dart';
export 'user_persona.dart';
export 'user_persona_type.dart';
export 'user_settings.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'project_records',
      dartName: 'ProjectRecord',
      schema: 'public',
      module: 'flutterforge_backend',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'project_records_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'projectId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'configJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'repoUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'githubUsername',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'iterationHistory',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'project_records_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'project_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'projectId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_settings',
      dartName: 'UserSettings',
      schema: 'public',
      module: 'flutterforge_backend',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'user_settings_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'geminiApiKey',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'githubToken',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_settings_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i5.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

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

    if (t == _i6.AiAnalysisResult) {
      return _i6.AiAnalysisResult.fromJson(data) as T;
    }
    if (t == _i7.AiDesignBrief) {
      return _i7.AiDesignBrief.fromJson(data) as T;
    }
    if (t == _i8.AppStyle) {
      return _i8.AppStyle.fromJson(data) as T;
    }
    if (t == _i9.ArchitectureConfig) {
      return _i9.ArchitectureConfig.fromJson(data) as T;
    }
    if (t == _i10.AssetFile) {
      return _i10.AssetFile.fromJson(data) as T;
    }
    if (t == _i11.CiCdConfig) {
      return _i11.CiCdConfig.fromJson(data) as T;
    }
    if (t == _i12.CiCdPlatform) {
      return _i12.CiCdPlatform.fromJson(data) as T;
    }
    if (t == _i13.ColorMode) {
      return _i13.ColorMode.fromJson(data) as T;
    }
    if (t == _i14.CustomPainterSpec) {
      return _i14.CustomPainterSpec.fromJson(data) as T;
    }
    if (t == _i15.DesignSource) {
      return _i15.DesignSource.fromJson(data) as T;
    }
    if (t == _i16.EnvironmentConfig) {
      return _i16.EnvironmentConfig.fromJson(data) as T;
    }
    if (t == _i17.FeatureLayer) {
      return _i17.FeatureLayer.fromJson(data) as T;
    }
    if (t == _i18.FeatureNode) {
      return _i18.FeatureNode.fromJson(data) as T;
    }
    if (t == _i19.FigmaConfig) {
      return _i19.FigmaConfig.fromJson(data) as T;
    }
    if (t == _i20.Greeting) {
      return _i20.Greeting.fromJson(data) as T;
    }
    if (t == _i21.IntegrationConfig) {
      return _i21.IntegrationConfig.fromJson(data) as T;
    }
    if (t == _i22.LayoutDensity) {
      return _i22.LayoutDensity.fromJson(data) as T;
    }
    if (t == _i23.LlmInstruction) {
      return _i23.LlmInstruction.fromJson(data) as T;
    }
    if (t == _i24.LocalizationConfig) {
      return _i24.LocalizationConfig.fromJson(data) as T;
    }
    if (t == _i25.MonetizationConfig) {
      return _i25.MonetizationConfig.fromJson(data) as T;
    }
    if (t == _i26.MonetizationModel) {
      return _i26.MonetizationModel.fromJson(data) as T;
    }
    if (t == _i27.NativeModuleSpec) {
      return _i27.NativeModuleSpec.fromJson(data) as T;
    }
    if (t == _i28.PipelineCommand) {
      return _i28.PipelineCommand.fromJson(data) as T;
    }
    if (t == _i29.PipelineEvent) {
      return _i29.PipelineEvent.fromJson(data) as T;
    }
    if (t == _i30.PipelinePhase) {
      return _i30.PipelinePhase.fromJson(data) as T;
    }
    if (t == _i31.PipelineStateMessage) {
      return _i31.PipelineStateMessage.fromJson(data) as T;
    }
    if (t == _i32.PostmanConfig) {
      return _i32.PostmanConfig.fromJson(data) as T;
    }
    if (t == _i33.ProjectConfig) {
      return _i33.ProjectConfig.fromJson(data) as T;
    }
    if (t == _i34.ProjectRecord) {
      return _i34.ProjectRecord.fromJson(data) as T;
    }
    if (t == _i35.PubDependency) {
      return _i35.PubDependency.fromJson(data) as T;
    }
    if (t == _i36.SubscriptionProvider) {
      return _i36.SubscriptionProvider.fromJson(data) as T;
    }
    if (t == _i37.TestingConfig) {
      return _i37.TestingConfig.fromJson(data) as T;
    }
    if (t == _i38.TypographyFeel) {
      return _i38.TypographyFeel.fromJson(data) as T;
    }
    if (t == _i39.UserPersona) {
      return _i39.UserPersona.fromJson(data) as T;
    }
    if (t == _i40.UserPersonaType) {
      return _i40.UserPersonaType.fromJson(data) as T;
    }
    if (t == _i41.UserSettings) {
      return _i41.UserSettings.fromJson(data) as T;
    }
    if (t == _i1.getType<_i6.AiAnalysisResult?>()) {
      return (data != null ? _i6.AiAnalysisResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AiDesignBrief?>()) {
      return (data != null ? _i7.AiDesignBrief.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AppStyle?>()) {
      return (data != null ? _i8.AppStyle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ArchitectureConfig?>()) {
      return (data != null ? _i9.ArchitectureConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.AssetFile?>()) {
      return (data != null ? _i10.AssetFile.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CiCdConfig?>()) {
      return (data != null ? _i11.CiCdConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.CiCdPlatform?>()) {
      return (data != null ? _i12.CiCdPlatform.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.ColorMode?>()) {
      return (data != null ? _i13.ColorMode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.CustomPainterSpec?>()) {
      return (data != null ? _i14.CustomPainterSpec.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.DesignSource?>()) {
      return (data != null ? _i15.DesignSource.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.EnvironmentConfig?>()) {
      return (data != null ? _i16.EnvironmentConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.FeatureLayer?>()) {
      return (data != null ? _i17.FeatureLayer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.FeatureNode?>()) {
      return (data != null ? _i18.FeatureNode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.FigmaConfig?>()) {
      return (data != null ? _i19.FigmaConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Greeting?>()) {
      return (data != null ? _i20.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.IntegrationConfig?>()) {
      return (data != null ? _i21.IntegrationConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.LayoutDensity?>()) {
      return (data != null ? _i22.LayoutDensity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.LlmInstruction?>()) {
      return (data != null ? _i23.LlmInstruction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.LocalizationConfig?>()) {
      return (data != null ? _i24.LocalizationConfig.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i25.MonetizationConfig?>()) {
      return (data != null ? _i25.MonetizationConfig.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.MonetizationModel?>()) {
      return (data != null ? _i26.MonetizationModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.NativeModuleSpec?>()) {
      return (data != null ? _i27.NativeModuleSpec.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.PipelineCommand?>()) {
      return (data != null ? _i28.PipelineCommand.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.PipelineEvent?>()) {
      return (data != null ? _i29.PipelineEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.PipelinePhase?>()) {
      return (data != null ? _i30.PipelinePhase.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.PipelineStateMessage?>()) {
      return (data != null ? _i31.PipelineStateMessage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.PostmanConfig?>()) {
      return (data != null ? _i32.PostmanConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.ProjectConfig?>()) {
      return (data != null ? _i33.ProjectConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.ProjectRecord?>()) {
      return (data != null ? _i34.ProjectRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.PubDependency?>()) {
      return (data != null ? _i35.PubDependency.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.SubscriptionProvider?>()) {
      return (data != null ? _i36.SubscriptionProvider.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.TestingConfig?>()) {
      return (data != null ? _i37.TestingConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.TypographyFeel?>()) {
      return (data != null ? _i38.TypographyFeel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.UserPersona?>()) {
      return (data != null ? _i39.UserPersona.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.UserPersonaType?>()) {
      return (data != null ? _i40.UserPersonaType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.UserSettings?>()) {
      return (data != null ? _i41.UserSettings.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i18.FeatureNode>) {
      return (data as List)
              .map((e) => deserialize<_i18.FeatureNode>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.PipelineEvent>) {
      return (data as List)
              .map((e) => deserialize<_i29.PipelineEvent>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i14.CustomPainterSpec>) {
      return (data as List)
              .map((e) => deserialize<_i14.CustomPainterSpec>(e))
              .toList()
          as T;
    }
    if (t == List<_i27.NativeModuleSpec>) {
      return (data as List)
              .map((e) => deserialize<_i27.NativeModuleSpec>(e))
              .toList()
          as T;
    }
    if (t == List<_i35.PubDependency>) {
      return (data as List)
              .map((e) => deserialize<_i35.PubDependency>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.LlmInstruction>) {
      return (data as List)
              .map((e) => deserialize<_i23.LlmInstruction>(e))
              .toList()
          as T;
    }
    if (t == List<_i10.AssetFile>) {
      return (data as List).map((e) => deserialize<_i10.AssetFile>(e)).toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == List<_i42.ProjectRecord>) {
      return (data as List)
              .map((e) => deserialize<_i42.ProjectRecord>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i5.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i6.AiAnalysisResult => 'AiAnalysisResult',
      _i7.AiDesignBrief => 'AiDesignBrief',
      _i8.AppStyle => 'AppStyle',
      _i9.ArchitectureConfig => 'ArchitectureConfig',
      _i10.AssetFile => 'AssetFile',
      _i11.CiCdConfig => 'CiCdConfig',
      _i12.CiCdPlatform => 'CiCdPlatform',
      _i13.ColorMode => 'ColorMode',
      _i14.CustomPainterSpec => 'CustomPainterSpec',
      _i15.DesignSource => 'DesignSource',
      _i16.EnvironmentConfig => 'EnvironmentConfig',
      _i17.FeatureLayer => 'FeatureLayer',
      _i18.FeatureNode => 'FeatureNode',
      _i19.FigmaConfig => 'FigmaConfig',
      _i20.Greeting => 'Greeting',
      _i21.IntegrationConfig => 'IntegrationConfig',
      _i22.LayoutDensity => 'LayoutDensity',
      _i23.LlmInstruction => 'LlmInstruction',
      _i24.LocalizationConfig => 'LocalizationConfig',
      _i25.MonetizationConfig => 'MonetizationConfig',
      _i26.MonetizationModel => 'MonetizationModel',
      _i27.NativeModuleSpec => 'NativeModuleSpec',
      _i28.PipelineCommand => 'PipelineCommand',
      _i29.PipelineEvent => 'PipelineEvent',
      _i30.PipelinePhase => 'PipelinePhase',
      _i31.PipelineStateMessage => 'PipelineStateMessage',
      _i32.PostmanConfig => 'PostmanConfig',
      _i33.ProjectConfig => 'ProjectConfig',
      _i34.ProjectRecord => 'ProjectRecord',
      _i35.PubDependency => 'PubDependency',
      _i36.SubscriptionProvider => 'SubscriptionProvider',
      _i37.TestingConfig => 'TestingConfig',
      _i38.TypographyFeel => 'TypographyFeel',
      _i39.UserPersona => 'UserPersona',
      _i40.UserPersonaType => 'UserPersonaType',
      _i41.UserSettings => 'UserSettings',
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
      case _i6.AiAnalysisResult():
        return 'AiAnalysisResult';
      case _i7.AiDesignBrief():
        return 'AiDesignBrief';
      case _i8.AppStyle():
        return 'AppStyle';
      case _i9.ArchitectureConfig():
        return 'ArchitectureConfig';
      case _i10.AssetFile():
        return 'AssetFile';
      case _i11.CiCdConfig():
        return 'CiCdConfig';
      case _i12.CiCdPlatform():
        return 'CiCdPlatform';
      case _i13.ColorMode():
        return 'ColorMode';
      case _i14.CustomPainterSpec():
        return 'CustomPainterSpec';
      case _i15.DesignSource():
        return 'DesignSource';
      case _i16.EnvironmentConfig():
        return 'EnvironmentConfig';
      case _i17.FeatureLayer():
        return 'FeatureLayer';
      case _i18.FeatureNode():
        return 'FeatureNode';
      case _i19.FigmaConfig():
        return 'FigmaConfig';
      case _i20.Greeting():
        return 'Greeting';
      case _i21.IntegrationConfig():
        return 'IntegrationConfig';
      case _i22.LayoutDensity():
        return 'LayoutDensity';
      case _i23.LlmInstruction():
        return 'LlmInstruction';
      case _i24.LocalizationConfig():
        return 'LocalizationConfig';
      case _i25.MonetizationConfig():
        return 'MonetizationConfig';
      case _i26.MonetizationModel():
        return 'MonetizationModel';
      case _i27.NativeModuleSpec():
        return 'NativeModuleSpec';
      case _i28.PipelineCommand():
        return 'PipelineCommand';
      case _i29.PipelineEvent():
        return 'PipelineEvent';
      case _i30.PipelinePhase():
        return 'PipelinePhase';
      case _i31.PipelineStateMessage():
        return 'PipelineStateMessage';
      case _i32.PostmanConfig():
        return 'PostmanConfig';
      case _i33.ProjectConfig():
        return 'ProjectConfig';
      case _i34.ProjectRecord():
        return 'ProjectRecord';
      case _i35.PubDependency():
        return 'PubDependency';
      case _i36.SubscriptionProvider():
        return 'SubscriptionProvider';
      case _i37.TestingConfig():
        return 'TestingConfig';
      case _i38.TypographyFeel():
        return 'TypographyFeel';
      case _i39.UserPersona():
        return 'UserPersona';
      case _i40.UserPersonaType():
        return 'UserPersonaType';
      case _i41.UserSettings():
        return 'UserSettings';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i5.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AiAnalysisResult') {
      return deserialize<_i6.AiAnalysisResult>(data['data']);
    }
    if (dataClassName == 'AiDesignBrief') {
      return deserialize<_i7.AiDesignBrief>(data['data']);
    }
    if (dataClassName == 'AppStyle') {
      return deserialize<_i8.AppStyle>(data['data']);
    }
    if (dataClassName == 'ArchitectureConfig') {
      return deserialize<_i9.ArchitectureConfig>(data['data']);
    }
    if (dataClassName == 'AssetFile') {
      return deserialize<_i10.AssetFile>(data['data']);
    }
    if (dataClassName == 'CiCdConfig') {
      return deserialize<_i11.CiCdConfig>(data['data']);
    }
    if (dataClassName == 'CiCdPlatform') {
      return deserialize<_i12.CiCdPlatform>(data['data']);
    }
    if (dataClassName == 'ColorMode') {
      return deserialize<_i13.ColorMode>(data['data']);
    }
    if (dataClassName == 'CustomPainterSpec') {
      return deserialize<_i14.CustomPainterSpec>(data['data']);
    }
    if (dataClassName == 'DesignSource') {
      return deserialize<_i15.DesignSource>(data['data']);
    }
    if (dataClassName == 'EnvironmentConfig') {
      return deserialize<_i16.EnvironmentConfig>(data['data']);
    }
    if (dataClassName == 'FeatureLayer') {
      return deserialize<_i17.FeatureLayer>(data['data']);
    }
    if (dataClassName == 'FeatureNode') {
      return deserialize<_i18.FeatureNode>(data['data']);
    }
    if (dataClassName == 'FigmaConfig') {
      return deserialize<_i19.FigmaConfig>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i20.Greeting>(data['data']);
    }
    if (dataClassName == 'IntegrationConfig') {
      return deserialize<_i21.IntegrationConfig>(data['data']);
    }
    if (dataClassName == 'LayoutDensity') {
      return deserialize<_i22.LayoutDensity>(data['data']);
    }
    if (dataClassName == 'LlmInstruction') {
      return deserialize<_i23.LlmInstruction>(data['data']);
    }
    if (dataClassName == 'LocalizationConfig') {
      return deserialize<_i24.LocalizationConfig>(data['data']);
    }
    if (dataClassName == 'MonetizationConfig') {
      return deserialize<_i25.MonetizationConfig>(data['data']);
    }
    if (dataClassName == 'MonetizationModel') {
      return deserialize<_i26.MonetizationModel>(data['data']);
    }
    if (dataClassName == 'NativeModuleSpec') {
      return deserialize<_i27.NativeModuleSpec>(data['data']);
    }
    if (dataClassName == 'PipelineCommand') {
      return deserialize<_i28.PipelineCommand>(data['data']);
    }
    if (dataClassName == 'PipelineEvent') {
      return deserialize<_i29.PipelineEvent>(data['data']);
    }
    if (dataClassName == 'PipelinePhase') {
      return deserialize<_i30.PipelinePhase>(data['data']);
    }
    if (dataClassName == 'PipelineStateMessage') {
      return deserialize<_i31.PipelineStateMessage>(data['data']);
    }
    if (dataClassName == 'PostmanConfig') {
      return deserialize<_i32.PostmanConfig>(data['data']);
    }
    if (dataClassName == 'ProjectConfig') {
      return deserialize<_i33.ProjectConfig>(data['data']);
    }
    if (dataClassName == 'ProjectRecord') {
      return deserialize<_i34.ProjectRecord>(data['data']);
    }
    if (dataClassName == 'PubDependency') {
      return deserialize<_i35.PubDependency>(data['data']);
    }
    if (dataClassName == 'SubscriptionProvider') {
      return deserialize<_i36.SubscriptionProvider>(data['data']);
    }
    if (dataClassName == 'TestingConfig') {
      return deserialize<_i37.TestingConfig>(data['data']);
    }
    if (dataClassName == 'TypographyFeel') {
      return deserialize<_i38.TypographyFeel>(data['data']);
    }
    if (dataClassName == 'UserPersona') {
      return deserialize<_i39.UserPersona>(data['data']);
    }
    if (dataClassName == 'UserPersonaType') {
      return deserialize<_i40.UserPersonaType>(data['data']);
    }
    if (dataClassName == 'UserSettings') {
      return deserialize<_i41.UserSettings>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i5.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i5.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i34.ProjectRecord:
        return _i34.ProjectRecord.t;
      case _i41.UserSettings:
        return _i41.UserSettings.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'flutterforge_backend';

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
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i5.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
