// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMAIUser _$NIMAIUserFromJson(Map<String, dynamic> json) => NIMAIUser(
      modelType:
          $enumDecodeNullable(_$NIMAIModelTypeEnumMap, json['modelType']),
      modelConfig: _nimAIModelConfigFromJson(json['modelConfig'] as Map?),
      accountId: json['accountId'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      sign: json['sign'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      email: json['email'] as String?,
      birthday: json['birthday'] as String?,
      mobile: json['mobile'] as String?,
      serverExtension: json['serverExtension'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMAIUserToJson(NIMAIUser instance) => <String, dynamic>{
      'accountId': instance.accountId,
      'name': instance.name,
      'avatar': instance.avatar,
      'sign': instance.sign,
      'gender': instance.gender,
      'email': instance.email,
      'birthday': instance.birthday,
      'mobile': instance.mobile,
      'serverExtension': instance.serverExtension,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'modelType': _$NIMAIModelTypeEnumMap[instance.modelType],
      'modelConfig': instance.modelConfig?.toJson(),
    };

const _$NIMAIModelTypeEnumMap = {
  NIMAIModelType.nimAiModelTypeUKnown: 0,
  NIMAIModelType.nimAiModelTypeQwen: 1,
  NIMAIModelType.nimAiModelTypeAzure: 2,
  NIMAIModelType.nimAiModelTypePrivate: 3,
};

NIMAIModelStreamCallChunk _$NIMAIModelStreamCallChunkFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelStreamCallChunk(
      content: json['content'] as String?,
      chunkTime: (json['chunkTime'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt() ?? 0,
      index: (json['index'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$NIMAIModelStreamCallChunkToJson(
        NIMAIModelStreamCallChunk instance) =>
    <String, dynamic>{
      'content': instance.content,
      'chunkTime': instance.chunkTime,
      'type': instance.type,
      'index': instance.index,
    };

NIMAIModelStreamCallContent _$NIMAIModelStreamCallContentFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelStreamCallContent(
      msg: json['msg'] as String?,
      type: (json['type'] as num?)?.toInt() ?? 0,
      lastChunk: NIMAIModelStreamCallChunkFromJson(json['lastChunk'] as Map?),
    );

Map<String, dynamic> _$NIMAIModelStreamCallContentToJson(
        NIMAIModelStreamCallContent instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'type': instance.type,
      'lastChunk': instance.lastChunk?.toJson(),
    };

NIMAIModelStreamCallResult _$NIMAIModelStreamCallResultFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelStreamCallResult(
      code: (json['code'] as num?)?.toInt() ?? 200,
      accountId: json['accountId'] as String,
      requestId: json['requestId'] as String,
      content: NIMAIModelStreamCallContentFromJson(json['content'] as Map?),
      aiRAGs: NIMAIRAGInfoListFromJson(json['aiRAGs'] as List?),
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NIMAIModelStreamCallResultToJson(
        NIMAIModelStreamCallResult instance) =>
    <String, dynamic>{
      'code': instance.code,
      'accountId': instance.accountId,
      'requestId': instance.requestId,
      'content': instance.content?.toJson(),
      'aiRAGs': instance.aiRAGs?.map((e) => e.toJson()).toList(),
      'timestamp': instance.timestamp,
    };

NIMAIModelStreamCallStopParams _$NIMAIModelStreamCallStopParamsFromJson(
        Map<String, dynamic> json) =>
    NIMAIModelStreamCallStopParams(
      accountId: json['accountId'] as String,
      requestId: json['requestId'] as String,
    );

Map<String, dynamic> _$NIMAIModelStreamCallStopParamsToJson(
        NIMAIModelStreamCallStopParams instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'requestId': instance.requestId,
    };
