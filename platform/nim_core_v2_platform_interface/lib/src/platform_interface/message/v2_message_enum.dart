// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

/// 消息附件上传状态
enum NIMMessageAttachmentUploadState {
  /// 未知
  @JsonValue(0)
  unknown,

  /// 上传成功
  @JsonValue(1)
  succeed,

  /// 上传失败
  @JsonValue(2)
  failed,

  /// 上传中
  @JsonValue(3)
  uploading,
}

/// 消息附件下载状态
enum NIMMessageAttachmentDownloadState {
  /// 未知
  @JsonValue(0)
  unknown,

  /// 下载成功
  @JsonValue(1)
  succeed,

  /// 下载失败
  @JsonValue(2)
  failed,

  /// 下载中
  @JsonValue(3)
  downloading,
}

/// 消息查询方向
enum NIMQueryDirection {
  /// 按时间戳从大到小查询
  @JsonValue(0)
  desc,

  /// 按时间戳从小到大查询
  @JsonValue(1)
  asc,
}

/// 快捷评论操作类型
enum NIMMessageQuickCommentType {
  /// 添加
  @JsonValue(1)
  add,

  /// 删除
  @JsonValue(2)
  remove,
}

/// 消息发送状态
enum NIMMessageSendingState {
  /// 未知
  @JsonValue(0)
  unknown,

  /// 发送成功
  @JsonValue(1)
  succeeded,

  /// 发送失败
  @JsonValue(2)
  failed,

  /// 发送中
  @JsonValue(3)
  sending,
}

/// 消息类型
enum NIMMessageType {
  ///< 未知， 不合法
  @JsonValue(-1)
  invalid,

  ///< 文本
  @JsonValue(0)
  text,

  ///< 图片
  @JsonValue(1)
  image,

  ///< 语音
  @JsonValue(2)
  audio,

  ///< 视频
  @JsonValue(3)
  video,

  ///< 地理位置
  @JsonValue(4)
  location,

  ///< 通知
  @JsonValue(5)
  notification,

  ///< 文件
  @JsonValue(6)
  file,

  ///<音视频通话
  @JsonValue(7)
  avChat,

  ///< 提醒
  @JsonValue(10)
  tip,

  ///< 机器人
  @JsonValue(11)
  robot,

  ///< 话单
  @JsonValue(12)
  call,

  ///< 自定义
  @JsonValue(100)
  custom,

  ///聊天室的通知，序列化使用，外部依然是[notification]
  @JsonValue(105)
  chatroomNotification,
}

/// 通知类型
enum NIMMessageNotificationType {
  ///< 群拉人
  @JsonValue(0)
  teamInvite,

  ///< 群踢人
  @JsonValue(1)
  teamKick,

  ///< 退出群
  @JsonValue(2)
  teamLeave,

  ///< 更新群信息
  @JsonValue(3)
  teamUpdateTInfo,

  ///< 群解散
  @JsonValue(4)
  teamDismiss,

  ///< 群申请加入通过
  @JsonValue(5)
  teamApplyPass,

  ///< 移交群主
  @JsonValue(6)
  teamOwnerTransfer,

  ///< 添加管理员
  @JsonValue(7)
  teamAddManager,

  ///< 移除管理员
  @JsonValue(8)
  teamRemoveManager,

  ///< 接受邀请进群
  @JsonValue(9)
  teamInviteAccept,

  ///< 禁言群成员
  @JsonValue(10)
  teamBannedTeamMember,

  ///< 群拉人
  @JsonValue(401)
  superTeamInvite,

  ///< 群踢人
  @JsonValue(402)
  superTeamKick,

  ///< 退出群
  @JsonValue(403)
  superTeamLeave,

  ///< 更新群信息
  @JsonValue(404)
  superTeamUpdateTinfo,

  ///< 群解散
  @JsonValue(405)
  superTeamDismiss,

  ///< 移交群主
  @JsonValue(406)
  superTeamOwnerTransfer,

  ///< 添加管理员
  @JsonValue(407)
  superTeamAddManager,

  ///< 移除管理员
  @JsonValue(408)
  superTeamRemoveManager,

  ///< 禁言群成员
  @JsonValue(409)
  superTeamBannedTeamMember,

  ///< 群申请加入通过
  @JsonValue(410)
  superTeamApplyPass,

  ///< 接受邀请进群
  @JsonValue(411)
  superTeamInviteAccept,
}

/// 消息状态
enum NIMMessageState {
  ///< 默认
  @JsonValue(0)
  stateDefault,

  ///< 已删除
  @JsonValue(1)
  stateDeleted,

  ///< 已撤回
  @JsonValue(2)
  stateRevoked,
}

/// 反垃圾命中
enum NIMClientAntispamOperateType {
  ///< 无操作
  @JsonValue(0)
  none,

  ///< 命中后，本地替换
  @JsonValue(1)
  replace,

  ///< 命中后，本地屏蔽，该消息拒绝发送
  @JsonValue(2)
  clientShield,

  ///< 命中后，消息可以发送，由服务器屏蔽
  @JsonValue(3)
  serverShield,
}

/// 大模型角色类型
enum NIMMessageAIStatus {
  ///< 普通消息
  @JsonValue(0)
  unknow,

  ///< 表示是一个艾特数字人的消息
  @JsonValue(1)
  at,

  ///< 表示是数字人响应艾特的消息
  @JsonValue(2)
  response,
}

/// 消息撤回类型
enum NIMMessageRevokeType {
  ///< 未定义
  @JsonValue(0)
  undefined,

  ///< 点对点双向撤回
  @JsonValue(1)
  p2pBothway,

  ///< 群双向撤回
  @JsonValue(2)
  teamBothway,

  ///< 超大群双向撤回
  @JsonValue(3)
  superTeamBothway,

  ///< 点对点单向撤回
  @JsonValue(4)
  p2pOneway,

  ///< 群单向撤回
  @JsonValue(5)
  teamOneway
}

/// 消息标记类型
enum NIMMessagePinState {
  ///< 未pin
  @JsonValue(0)
  notPinned,

  ///< 已pin
  @JsonValue(1)
  pinned,

  ///< 已pin状态更新
  @JsonValue(2)
  updated,
}

/// 大模型请求内容类型
enum NIMAIModelCallContentType {
  // 暂时只有0，代表文本，预留扩展能力
  @JsonValue(0)
  text,
}

/// 大模型角色内容
enum NIMAIModelRoleType {
  @JsonValue(0)
  system,

  @JsonValue(1)
  user,

  @JsonValue(2)
  assistant
}

///停止流式输出操作的类型。
enum V2NIMMessageAIStreamStopOpType {
  ///停止输出保持现状
  @JsonValue(0)
  V2NIM_MESSAGE_AI_STREAM_STOP_OP_DEFAULT,

  ///停止并撤回消息
  @JsonValue(1)
  V2NIM_MESSAGE_AI_STREAM_STOP_OP_REVOKE,

  ///停止并更新消息内容
  @JsonValue(2)
  V2NIM_MESSAGE_AI_STREAM_STOP_OP_UPDATE;
}

///重新输出数字人消息操作的类型。
enum V2NIMMessageAIRegenOpType {
  /// 更新消息
  /// 不会生成新消息，而是更新现有的消息内容
  @JsonValue(1)
  V2NIM_MESSAGE_AI_REGEN_OP_UPDATE,

  /// 生成新消息
  ///  生成一条新的消息
  @JsonValue(2)
  V2NIM_MESSAGE_AI_REGEN_OP_NEW;
}

enum V2NIMMessageAIStreamStatus {
  /// 流式过程中 (本地状态，其他为服务器状态)
  @JsonValue(-1)
  V2NIM_MESSAGE_AI_STREAM_STATUS_STREAMING,

  /// 非流式状态
  @JsonValue(0)
  V2NIM_MESSAGE_AI_STREAM_STATUS_NONE,

  /// 占位
  @JsonValue(1)
  V2NIM_MESSAGE_AI_STREAM_STATUS_PLACEHOLDER,

  /// 停止输出
  @JsonValue(2)
  V2NIM_MESSAGE_AI_STREAM_STATUS_STOPPED,

  /// 停止并更新
  @JsonValue(3)
  V2NIM_MESSAGE_AI_STREAM_STATUS_UPDATED,

  /// 输出完成
  @JsonValue(4)
  V2NIM_MESSAGE_AI_STREAM_STATUS_GENERATED,

  /// 服务器异常终止
  @JsonValue(5)
  V2NIM_MESSAGE_AI_STREAM_STATUS_ABORTED,
}

///数字人代理请求流式响应状态。
enum V2NIMAIModelStreamCallStatus {
  /// 非流式状态
  /// 值为0
  @JsonValue(0)
  V2NIM_AI_MODEL_STREAM_CALL_STATUS_NONE,

  /// 停止输出
  /// 值为2
  @JsonValue(2)
  V2NIM_AI_MODEL_STREAM_CALL_STATUS_STOPPED,

  /// 输出完成
  /// 值为4
  @JsonValue(4)
  V2NIM_AI_MODEL_STREAM_CALL_STATUS_GENERATED,

  /// 服务器异常终止
  /// 值为5
  @JsonValue(5)
  V2NIM_AI_MODEL_STREAM_CALL_STATUS_ABORTED,
}

///清理历史消息模式
enum NIMClearHistoryMode {
  /// 同时删除云端和本地
  @JsonValue(0)
  V2NIM_CLEAR_HISTORY_MODE_ALL,

  /// 仅删除本地, 云端拉取可以恢复
  @JsonValue(1)
  V2NIM_CLEAR_HISTORY_MODE_LOCAL,

  ///仅删除本地, 云端拉取也不可能恢复， 状态记录在本地， 卸载重装后， 数据会重新出现
  @JsonValue(2)
  V2NIM_CLEAR_HISTORY_MODE_LOCAL_IRREPARABLY
}
