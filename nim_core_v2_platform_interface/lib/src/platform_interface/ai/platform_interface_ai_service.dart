// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../method_channel/method_channel_ai_service.dart';

abstract class AIServicePlatform extends Service {
  AIServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static AIServicePlatform _instance = MethodChannelAIService();

  static AIServicePlatform get instance => _instance;

  static set instance(AIServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// AI 消息的响应的回调
  Stream<NIMAIModelCallResult> get onProxyAIModelCall;

  ///AI 消息的流式响应的回调
  /// 注意：流式过程中回调此方法，流式结束后还是会统一调用onProxyAIModelCall方法
  Stream<NIMAIModelStreamCallResult> get onProxyAIModelStreamCall;

  /// 数字人拉取接口
  Future<NIMResult<List<NIMAIUser>>> getAIUserList() {
    throw UnimplementedError('getAIUserList() is not implemented');
  }

  /// AI 数字人请求代理接口
  Future<NIMResult<void>> proxyAIModelCall(NIMProxyAIModelCallParams params) {
    throw UnimplementedError('proxyAIModelCall() is not implemented');
  }

  /// 停止流式输出接口
  Future<NIMResult<void>> stopAIModelStreamCall(
      NIMAIModelStreamCallStopParams params) {
    throw UnimplementedError('stopAIModelStreamCall() is not implemented');
  }
}
