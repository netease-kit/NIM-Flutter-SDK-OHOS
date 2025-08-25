// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

enum AIServieMethodType: String {
  case getAIUserList
  case proxyAIModelCall
  case stopAIModelStreamCall
}

class FLTAIService: FLTBaseService, FLTService, V2NIMAIListener {
  override func onInitialized() {
    NIMSDK.shared().v2AIService.add(self)
  }

  deinit {
    NIMSDK.shared().v2AIService.remove(self)
  }

  func serviceName() -> String {
    ServiceType.AIService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case AIServieMethodType.getAIUserList.rawValue:
      getAIUserList(arguments, resultCallback)
    case AIServieMethodType.proxyAIModelCall.rawValue:
      proxyAIModelCall(arguments, resultCallback)
    case AIServieMethodType.stopAIModelStreamCall.rawValue:
      stopAIModelStreamCall(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func proxyAIModelCall(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let params = V2NIMProxyAIModelCallParams.fromDic(paramsDic)
    NIMSDK.shared().v2AIService.proxyAIModelCall(params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func stopAIModelStreamCall(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let paramsDic = arguments["params"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    let params = V2NIMAIModelStreamCallStopParams.fromDic(paramsDic)
    NIMSDK.shared().v2AIService.stopAIModelStreamCall(params) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func getAIUserList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    NIMSDK.shared().v2AIService.getAIUserList { aiUsers in
      var userList = [[String: Any]]()
      aiUsers?.forEach { aiUser in
        userList.append(aiUser.toDic())
      }
      weakSelf?.successCallBack(resultCallback, ["userList": userList])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onProxyAIModelCall(_ data: V2NIMAIModelCallResult) {
    notifyEvent(serviceName(), "onProxyAIModelCall", data.toDic())
  }

  func onProxyAIModelStreamCall(_ data: V2NIMAIModelStreamCallResult) {
    notifyEvent(serviceName(), "onProxyAIModelStreamCall", data.toDic())
  }
}
