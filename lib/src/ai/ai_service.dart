// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

part of nim_core_v2;

@HawkEntryPoint()
class AiService {
  factory AiService() {
    if (_singleton == null) {
      _singleton = AiService._();
    }
    return _singleton!;
  }

  AiService._();

  static AiService? _singleton;

  AIServicePlatform get _platform => AIServicePlatform.instance;

  /// AI 消息的响应的回调
  @HawkApi(ignore: true)
  Stream<NIMAIModelCallResult> get onProxyAIModelCall =>
      _platform.onProxyAIModelCall;

  ///AI 消息的流式响应的回调
  /// 注意：流式过程中回调此方法，流式结束后还是会统一调用onProxyAIModelCall方法
  Stream<NIMAIModelStreamCallResult> get onProxyAIModelStreamCall =>
      _platform.onProxyAIModelStreamCall;

  /// 数字人拉取接口
  Future<NIMResult<List<NIMAIUser>>> getAIUserList() =>
      _platform.getAIUserList();

  /// AI 数字人请求代理接口
  Future<NIMResult<void>> proxyAIModelCall(NIMProxyAIModelCallParams params) =>
      _platform.proxyAIModelCall(params);

  /// 停止流式输出接口
  Future<NIMResult<void>> stopAIModelStreamCall(
          NIMAIModelStreamCallStopParams params) =>
      _platform.stopAIModelStreamCall(params);
}
