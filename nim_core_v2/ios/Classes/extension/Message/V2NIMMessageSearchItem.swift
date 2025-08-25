// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMMessageSearchItem {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
//  static func fromDic(_ arguments: [String: Any]) -> V2NIMMessageSearchItem {
//    let result = V2NIMMessageSearchItem()
//
//
//    return result
//  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(conversationId)] = conversationId
    keyPaths[#keyPath(count)] = count
    keyPaths[#keyPath(messages)] = messages.map { msg in
      msg.toDict()
    }
    return keyPaths
  }
}
