// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
part 'nim_sdk_ohos_options.g.dart';

@JsonSerializable()
class NIMOHOSSDKOptions extends NIMSDKOptions {
  ///
  /// 日志分级， SDK 将根据您设置的级别，进行日志采集，建议您，将log级别设置为 Debug。您也可以不进行设置，默认级别就是Debug
  /// 可选值 "Error" | "Warn" | "Info" | "Debug"。
  /// 和鸿蒙系统日志方案相同， 如果选择 Debug， 将输出全部等级log，选择Error 只会输出Error 级别log
  ///
  @JsonKey(defaultValue: LogLevel.Debug)
  final LogLevel? logLevel;

  ///
  /// 建立连接时的 xhr 请求的超时时间。默认为 30000 ms
  ///
  @JsonKey(defaultValue: 30000)
  final int xhrConnectTimeout;

  ///
  /// 建立 socket 长连接的超时时间。默认为 30000 ms
  ///
  @JsonKey(defaultValue: 30000)
  final int socketConnectTimeout;

  ///
  /// 是否将SDK log 输出到控制台, 默认不输出。
  ///
  @JsonKey(defaultValue: false)
  final bool isOpenConsoleLog;

  ///
  /// 是否将过滤输出到日志文件内信息。
  ///
  @JsonKey(defaultValue: false)
  final bool isFilteringLog;

  /// 配置专属服务器的地址
  @JsonKey(fromJson: _serverOptionFromMap, toJson: _serverOptionToJson)
  final NIMServiceOptions? serverOptions;

  NIMOHOSSDKOptions({
    /// ohos configurations
    this.logLevel,
    this.xhrConnectTimeout = 30000,
    this.socketConnectTimeout = 2000,
    this.isOpenConsoleLog = false,
    this.isFilteringLog = false,
    this.serverOptions,

    /// common configurations
    required String appKey,
    String? sdkRootDir,
    int? cdnTrackInterval,
    int? customClientType,
    bool? shouldSyncStickTopSessionInfos,
    bool? enableReportLogAutomatically,
    String? loginCustomTag,
    bool? enableDatabaseBackup,
    bool? shouldSyncUnreadCount,
    bool? shouldConsiderRevokedMessageUnreadCount,
    bool? enableTeamMessageReadReceipt,
    bool? shouldTeamNotificationMessageMarkUnread,
    bool? enableAnimatedImageThumbnail,
    bool? enablePreloadMessageAttachment,
    bool? useAssetServerAddressConfig,
    Map<NIMNosScene, int>? nosSceneConfig,
    NIMServerConfig? serverConfig,
    bool enableFcs = true,
  }) : super(
          appKey: appKey,
          sdkRootDir: sdkRootDir,
          cdnTrackInterval: cdnTrackInterval,
          customClientType: customClientType,
          shouldSyncStickTopSessionInfos: shouldSyncStickTopSessionInfos,
          enableReportLogAutomatically: enableReportLogAutomatically,
          loginCustomTag: loginCustomTag,
          enableDatabaseBackup: enableDatabaseBackup,
          shouldSyncUnreadCount: shouldSyncUnreadCount,
          shouldConsiderRevokedMessageUnreadCount:
              shouldConsiderRevokedMessageUnreadCount,
          enableTeamMessageReadReceipt: enableTeamMessageReadReceipt,
          shouldTeamNotificationMessageMarkUnread:
              shouldTeamNotificationMessageMarkUnread,
          enableAnimatedImageThumbnail: enableAnimatedImageThumbnail,
          enablePreloadMessageAttachment: enablePreloadMessageAttachment,
          useAssetServerAddressConfig: useAssetServerAddressConfig,
          nosSceneConfig: nosSceneConfig,
          serverConfig: serverConfig,
          enableFcs: enableFcs,
        );

  factory NIMOHOSSDKOptions.fromMap(Map options) =>
      _$NIMOHOSSDKOptionsFromJson(Map<String, dynamic>.from(options));

  @override
  Map<String, dynamic> toMap() => _$NIMOHOSSDKOptionsToJson(this);
}

NIMServiceOptions? _serverOptionFromMap(Map? map) => map == null
    ? null
    : NIMServiceOptions.fromJson(map.cast<String, dynamic>());

Map? _serverOptionToJson(NIMServiceOptions? serverOption) =>
    serverOption?.toJson();

/// 服务配置选项总类
@JsonSerializable(explicitToJson: true)
class NIMServiceOptions {
  /// 登录模块特殊配置
  @JsonKey(fromJson: _LoginServiceConfigFromMap)
  final NIMOHLoginServiceConfig? loginServiceConfig;

  /// 消息模块配置
  @JsonKey(fromJson: _messageServiceConfigFromMap)
  final NIMMessageServiceConfig? messageServiceConfig;

  /// 推送配置
  @JsonKey(fromJson: _pushServiceConfigFromMap)
  final NIMPushServiceConfig? pushServiceConfig;

  /// HTTP配置
  @JsonKey(fromJson: _httpServiceConfigFromMap)
  final NIMHttpServiceConfig? httpServiceConfig;

  /// 数据库配置
  @JsonKey(fromJson: _databaseOptionsFromMap)
  final DatabaseOptions? databaseOptions;

  /// 存储服务配置
  @JsonKey(fromJson: _storageServiceConfigFromMap)
  final NIMStorageServiceConfig? storageServiceConfig;

  /// 云端会话配置
  @JsonKey(fromJson: _conversationConfigFromMap)
  final V2NIMConversationConfig? conversationConfig;

  /// 本地会话配置
  @JsonKey(fromJson: _localConversationConfigFromMap)
  final LocalConversationConfig? localConversationConfig;

  /// 数据上报配置
  @JsonKey(fromJson: _dataReporterConfigFromMap)
  final DataReporterConfig? dataReporterConfig;

  NIMServiceOptions({
    this.loginServiceConfig,
    this.messageServiceConfig,
    this.pushServiceConfig,
    this.httpServiceConfig,
    this.databaseOptions,
    this.storageServiceConfig,
    this.conversationConfig,
    this.localConversationConfig,
    this.dataReporterConfig,
  });

  factory NIMServiceOptions.fromJson(Map<String, dynamic> json) =>
      _$NIMServiceOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$NIMServiceOptionsToJson(this);
}

/// 基础服务配置
@JsonSerializable()
class NIMServiceConfig {
  /// 登录账号
  @JsonKey(defaultValue: [])
  final List<String>? services;

  NIMServiceConfig({
    this.services,
  });

  factory NIMServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMServiceConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NIMServiceConfigToJson(this);
}

NIMOHLoginServiceConfig? _LoginServiceConfigFromMap(Map? map) => map == null
    ? null
    : NIMOHLoginServiceConfig.fromJson(map.cast<String, dynamic>());

NIMMessageServiceConfig? _messageServiceConfigFromMap(Map? map) => map == null
    ? null
    : NIMMessageServiceConfig.fromJson(map.cast<String, dynamic>());

NIMPushServiceConfig? _pushServiceConfigFromMap(Map? map) => map == null
    ? null
    : NIMPushServiceConfig.fromJson(map.cast<String, dynamic>());

NIMHttpServiceConfig? _httpServiceConfigFromMap(Map? map) => map == null
    ? null
    : NIMHttpServiceConfig.fromJson(map.cast<String, dynamic>());
DatabaseOptions? _databaseOptionsFromMap(Map? map) =>
    map == null ? null : DatabaseOptions.fromJson(map.cast<String, dynamic>());
NIMStorageServiceConfig? _storageServiceConfigFromMap(Map? map) => map == null
    ? null
    : NIMStorageServiceConfig.fromJson(map.cast<String, dynamic>());
V2NIMConversationConfig? _conversationConfigFromMap(Map? map) => map == null
    ? null
    : V2NIMConversationConfig.fromJson(map.cast<String, dynamic>());
LocalConversationConfig? _localConversationConfigFromMap(Map? map) =>
    map == null
        ? null
        : LocalConversationConfig.fromJson(map.cast<String, dynamic>());
DataReporterConfig? _dataReporterConfigFromMap(Map? map) => map == null
    ? null
    : DataReporterConfig.fromJson(map.cast<String, dynamic>());

/// 登录模块配置
@JsonSerializable()
class NIMOHLoginServiceConfig extends NIMServiceConfig {
  NIMOHLoginServiceConfig({
    super.services,
    this.lbsUrls,
    this.linkUrl,
    this.customClientType,
    this.customTag,
    this.isHttps,
    this.supportProtocolFamily,
  });

  @JsonKey(defaultValue: [])
  final List<String>? lbsUrls;

  @JsonKey(defaultValue: null)
  final String? linkUrl;

  @JsonKey(defaultValue: null)
  final int? customClientType;

  @JsonKey(defaultValue: null)
  final String? customTag;

  @JsonKey(defaultValue: false)
  final bool? isHttps;

  @JsonKey(defaultValue: null)
  final NIMProtocolFamily? supportProtocolFamily;

  factory NIMOHLoginServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMOHLoginServiceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NIMOHLoginServiceConfigToJson(this);
}

enum NIMProtocolFamily {
  @JsonValue(0)
  IPV4,

  @JsonValue(1)
  IPV6,

  @JsonValue(2)
  DUAL_STACK,
}

/// 消息模块配置
@JsonSerializable()
class NIMMessageServiceConfig extends NIMServiceConfig {
  NIMMessageServiceConfig({super.services, this.shouldIgnore});

  /// 消息过滤函数
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool Function(dynamic msg)? shouldIgnore;

  factory NIMMessageServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMMessageServiceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NIMMessageServiceConfigToJson(this);
}

/// 推送配置
@JsonSerializable()
class NIMPushServiceConfig extends NIMServiceConfig {
  NIMPushServiceConfig({super.services, this.harmonyCertificateName});

  @JsonKey(defaultValue: null)
  final String? harmonyCertificateName;

  factory NIMPushServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMPushServiceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NIMPushServiceConfigToJson(this);
}

/// HTTP服务配置
@JsonSerializable()
class NIMHttpServiceConfig extends NIMServiceConfig {
  /// NOS上传地址（分片）
  final String? chunkUploadHost;

  /// 发送文件消息中文件的url的通配符地址
  final String? uploadReplaceFormat;

  NIMHttpServiceConfig({
    super.services,
    this.chunkUploadHost,
    this.uploadReplaceFormat,
  });

  factory NIMHttpServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMHttpServiceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NIMHttpServiceConfigToJson(this);
}

/// 数据库配置
@JsonSerializable()
class DatabaseOptions extends NIMServiceConfig {
  /// 初始化appKey（必须与初始化使用的一致）
  final String appKey;

  /// 数据库安全级别（默认S1）
  @JsonKey(defaultValue: 1)
  final int? securityLevel;

  /// 是否加密（默认不加密）
  @JsonKey(defaultValue: false)
  final bool? encrypt;

  DatabaseOptions({
    super.services,
    required this.appKey,
    this.securityLevel,
    this.encrypt,
  });

  factory DatabaseOptions.fromJson(Map<String, dynamic> json) =>
      _$DatabaseOptionsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DatabaseOptionsToJson(this);
}

/// 存储服务配置
@JsonSerializable()
class NIMStorageServiceConfig extends NIMServiceConfig {
  /// NOS下载地址
  final String? downloadHost;

  /// 下载url通配符地址
  final String? downloadReplaceFormat;

  NIMStorageServiceConfig({
    super.services,
    this.downloadHost,
    this.downloadReplaceFormat,
  });

  factory NIMStorageServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMStorageServiceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NIMStorageServiceConfigToJson(this);
}

/// 云端会话配置
@JsonSerializable()
class V2NIMConversationConfig extends NIMServiceConfig {
  /// 历史会话加载限制（默认10000）
  @JsonKey(defaultValue: 10000)
  final int? loadHistoryConversationLimit;

  V2NIMConversationConfig({
    super.services,
    this.loadHistoryConversationLimit,
  });

  factory V2NIMConversationConfig.fromJson(Map<String, dynamic> json) =>
      _$V2NIMConversationConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$V2NIMConversationConfigToJson(this);
}

/// 本地会话配置
@JsonSerializable()
class LocalConversationConfig extends NIMServiceConfig {
  /// 未读数过滤函数
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool Function(dynamic msg)? unreadCountFilterFn;

  /// 最后一条消息过滤函数
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool Function(dynamic msg)? lastMessageFilterFn;

  LocalConversationConfig({
    super.services,
    this.unreadCountFilterFn,
    this.lastMessageFilterFn,
  });

  factory LocalConversationConfig.fromJson(Map<String, dynamic> json) =>
      _$LocalConversationConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LocalConversationConfigToJson(this);
}

/// 数据上报配置
@JsonSerializable()
class DataReporterConfig extends NIMServiceConfig {
  /// 是否关闭异常上报（默认false，即开启）
  @JsonKey(defaultValue: false)
  final bool isCloseDataReporter;

  /// 异常上报地址
  final String? dataReporterAddress;

  DataReporterConfig({
    super.services,
    required this.isCloseDataReporter,
    this.dataReporterAddress,
  });

  factory DataReporterConfig.fromJson(Map<String, dynamic> json) =>
      _$DataReporterConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DataReporterConfigToJson(this);
}

/// 本地会话设置（原V2NIMLocalConversationConfig）
@JsonSerializable()
class V2NIMLocalConversationConfig extends NIMServiceConfig {
  V2NIMLocalConversationConfig({
    super.services,
  });

  factory V2NIMLocalConversationConfig.fromJson(Map<String, dynamic> json) =>
      _$V2NIMLocalConversationConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$V2NIMLocalConversationConfigToJson(this);
}

enum LogLevel {
  @JsonValue(0)
  Debug,
  @JsonValue(1)
  Info,
  @JsonValue(2)
  Warn,
  @JsonValue(3)
  Error
}
