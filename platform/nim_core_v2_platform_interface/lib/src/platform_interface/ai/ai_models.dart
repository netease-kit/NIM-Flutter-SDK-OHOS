// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';
import '../../../nim_core_v2_platform_interface.dart';

part 'ai_models.g.dart';

@JsonSerializable(explicitToJson: true)
class NIMAIUser extends NIMUserInfo {
  ///大模型类型
  NIMAIModelType? modelType;

  ///大模型配置
  @JsonKey(fromJson: _nimAIModelConfigFromJson)
  NIMAIModelConfig? modelConfig;

  NIMAIUser(
      {this.modelType,
      this.modelConfig,
      String? accountId,
      String? name,
      String? avatar,
      String? sign,
      int? gender,
      String? email,
      String? birthday,
      String? mobile,
      String? serverExtension,
      int? createTime,
      int? updateTime})
      : super(
            accountId: accountId,
            name: name,
            avatar: avatar,
            sign: sign,
            gender: gender,
            email: email,
            birthday: birthday,
            mobile: mobile,
            serverExtension: serverExtension,
            createTime: createTime,
            updateTime: updateTime);

  Map<String, dynamic> toJson() => _$NIMAIUserToJson(this);

  factory NIMAIUser.fromJson(Map<String, dynamic> map) =>
      _$NIMAIUserFromJson(map);
}

NIMAIModelConfig? _nimAIModelConfigFromJson(Map? map) {
  if (map != null) {
    return NIMAIModelConfig.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

enum NIMAIModelType {
  /// 未知
  @JsonValue(0)
  nimAiModelTypeUKnown,

  /// 通义千问
  @JsonValue(1)
  nimAiModelTypeQwen,

  /// 微软Azure
  @JsonValue(2)
  nimAiModelTypeAzure,

  /// 私有本地大模型
  @JsonValue(3)
  nimAiModelTypePrivate;
}

NIMAIModelStreamCallChunk? NIMAIModelStreamCallChunkFromJson(Map? map) {
  if (map != null) {
    return NIMAIModelStreamCallChunk.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///代理请求响应的流式分片信息。
@JsonSerializable(explicitToJson: true)
class NIMAIModelStreamCallChunk {
  ///数字人流式回复分片文本
  String? content;

  ///数字人流式回复当前分片时间
  int? chunkTime;

  ///类型，当前仅支持0表示文本
  int type = 0;

  ///分片序号，从0开始
  int index = 0;

  NIMAIModelStreamCallChunk(
      {this.content, this.chunkTime, this.type = 0, this.index = 0});

  factory NIMAIModelStreamCallChunk.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelStreamCallChunkFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelStreamCallChunkToJson(this);
}

///代理请求响应的流式回复内容。
@JsonSerializable(explicitToJson: true)
class NIMAIModelStreamCallContent {
  ///数字人流式回复分片组装好后的文本
  String? msg;

  ///类型，当前仅支持0表示文本
  int type = 0;

  ///数字人流式回复最近一个分片
  @JsonKey(fromJson: NIMAIModelStreamCallChunkFromJson)
  NIMAIModelStreamCallChunk? lastChunk;

  NIMAIModelStreamCallContent({this.msg, this.type = 0, this.lastChunk});

  factory NIMAIModelStreamCallContent.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelStreamCallContentFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelStreamCallContentToJson(this);
}

///数字人请求代理接口的流式回复的结构体。
@JsonSerializable(explicitToJson: true)
class NIMAIModelStreamCallResult {
  ///AI 响应的状态码。
  ///默认值为200，表示请求成功。
  int code = 200;

  ///获取数字人的 accountId。
  ///这是数字人唯一的标识符。
  String accountId;

  ///获取本次响应的标识。
  ///每次请求都会生成一个唯一的 requestId，用于追踪请求和响应。
  String requestId;

  ///请求 AI 的回复内容。
  ///这个对象包含了流式回复的具体内容。
  @JsonKey(fromJson: NIMAIModelStreamCallContentFromJson)
  NIMAIModelStreamCallContent? content;

  ///获取数字人回复内容的引用资源列表。
  ///这些资源可能包含图片、音频等多媒体信息。
  @JsonKey(fromJson: NIMAIRAGInfoListFromJson)
  List<NIMAIRAGInfo>? aiRAGs;

  ///获取分片的时间戳。
  ///表示该分片生成的时间点。
  int? timestamp;

  NIMAIModelStreamCallResult(
      {this.code = 200,
      required this.accountId,
      required this.requestId,
      this.content,
      this.aiRAGs,
      this.timestamp});

  factory NIMAIModelStreamCallResult.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelStreamCallResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelStreamCallResultToJson(this);
}

NIMAIModelStreamCallContent? NIMAIModelStreamCallContentFromJson(Map? map) {
  if (map != null) {
    return NIMAIModelStreamCallContent.fromJson(map.cast<String, dynamic>());
  }
  return null;
}

///停止数字人代理请求的 AI 流式回复参数。
@JsonSerializable(explicitToJson: true)
class NIMAIModelStreamCallStopParams {
  ///机器人账号ID，AIUser对应的账号ID
  String accountId;

  ///请求id
  String requestId;

  NIMAIModelStreamCallStopParams(
      {required this.accountId, required this.requestId});

  factory NIMAIModelStreamCallStopParams.fromJson(Map<String, dynamic> map) =>
      _$NIMAIModelStreamCallStopParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMAIModelStreamCallStopParamsToJson(this);
}
