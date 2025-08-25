// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "NimCore.h"

#include <FlutterMacOS/FlutterMacOS.h>

#include <iostream>

#include "FLTConvert.h"
#include "FLTService.h"
#include "common/services/FLTAIService.h"
#include "common/services/FLTChatRoomService.h"
#include "common/services/FLTChatroomClient.h"
#include "common/services/FLTChatroomMessageCreator.h"
#include "common/services/FLTChatroomQueueService.h"
#include "common/services/FLTConversationIdUtil.h"
#include "common/services/FLTConversationService.h"
#include "common/services/FLTFriendService.h"
#include "common/services/FLTInitializeService.h"
#include "common/services/FLTLocalConversationService.h"
#include "common/services/FLTLoginService.h"
#include "common/services/FLTMessageCreator.h"
#include "common/services/FLTMessageService.h"
#include "common/services/FLTNotificationService.h"
#include "common/services/FLTSignallingService.h"
#include "common/services/FLTStorageService.h"
#include "common/services/FLTSubscriptionService.h"
#include "common/services/V2FLTSettingsService.h"
#include "common/services/V2FLTTeamService.h"
#include "common/services/V2FLTUserService.h"

const std::string kFLTNimCoreService = "serviceName";

class NimMethodChannel {
 public:
  NimMethodChannel() {}

  void setMethodChannel(void* pChannel) { m_channel = (__bridge id)pChannel; }

  void invokeMethod(const std::string& eventName, const flutter::EncodableMap& arguments) {
    nim_cpp_wrapper_util::Json::Value value;
    Convert::getInstance()->convertMap2Json(&arguments, value);
    std::string strvalue = nim::GetJsonStringWithNoStyled(value);
    NSString* str = [NSString stringWithCString:strvalue.c_str() encoding:NSUTF8StringEncoding];
    NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError* err;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    // NSLog(@"invokeMethod eventName: %@", [NSString stringWithCString:eventName.c_str()
    // encoding:NSUTF8StringEncoding]); NSLog(@"invokeMethod dic: %@", dic);

    NSString* nsEventName = [NSString stringWithCString:eventName.c_str()
                                               encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
      [m_channel invokeMethod:nsEventName arguments:dic];
    });
  }

  void invokeMethod(const std::string& eventName, const flutter::EncodableMap& arguments,
                    const NimCore::InvokeMehtodCallback& callback) {
    nim_cpp_wrapper_util::Json::Value value;
    Convert::getInstance()->convertMap2Json(&arguments, value);
    std::string strvalue = nim::GetJsonStringWithNoStyled(value);
    NSString* str = [NSString stringWithCString:strvalue.c_str() encoding:NSUTF8StringEncoding];
    NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError* err;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];

    NSString* nsEventName = [NSString stringWithCString:eventName.c_str()
                                               encoding:NSUTF8StringEncoding];
    __block auto cb = callback;
    dispatch_async(dispatch_get_main_queue(), ^{
      [m_channel invokeMethod:nsEventName
                    arguments:dic
                       result:^(id result) {
                         // 处理来自 Dart 层的返回值
                         if ([nsEventName isEqualToString:@"getReconnectDelay"]) {
                           if (result != nil && ![result isKindOfClass:[NSNull class]]) {
                             NSNumber* returnValue = (NSNumber*)result;
                             int32_t intValue = [returnValue unsignedIntValue];
                             auto value = flutter::EncodableValue(intValue);
                             cb(value);
                           } else {
                             //  auto emptyValue = flutter::EncodableValue("");
                             cb(std::nullopt);
                           }
                         } else {
                           if (result != nil && ![result isKindOfClass:[NSNull class]]) {
                             if ([result isKindOfClass:[NSArray class]]) {
                               NSArray<NSString*>* returnValueStr = (NSArray<NSString*>*)result;
                               // 显式转换为 EncodableList
                               flutter::EncodableList encodableList;
                               std::vector<std::string> resultVector;
                               for (NSString* valueStr : returnValueStr) {
                                 std::string cppStr = std::string([valueStr UTF8String]);
                                 resultVector.push_back(cppStr);
                               }

                               for (const auto& str : resultVector) {
                                 encodableList.push_back(flutter::EncodableValue(str));
                               }

                               auto value = flutter::EncodableValue(encodableList);
                               cb(value);
                             } else if ([result isKindOfClass:[FlutterError class]]) {
                               flutter::EncodableMap encodableMap;
                               auto value = flutter::EncodableValue(encodableMap);
                               cb(value);
                             } else {
                               NSString* returnValueStr = (NSString*)result;
                               std::string cppStr = std::string([returnValueStr UTF8String]);
                               auto value = flutter::EncodableValue(cppStr);
                               cb(value);
                             }

                           } else {
                             //  auto emptyValue = flutter::EncodableValue("");
                             cb(std::nullopt);
                           }
                         }
                       }];
    });
  }

 private:
  FlutterMethodChannel* m_channel;
};

NimCore::NimCore() {
  addService(new FLTInitializeService());
  m_methodChannel = new NimMethodChannel();
}

NimCore::~NimCore() {}

void NimCore::regService() {
  addService(new FLTLoginService());
  addService(new FLTAIService());
  addService(new FLTNotificationService());
  addService(new FLTStorageService());
  addService(new FLTMessageService());
  addService(new FLTChatRoomService());
  addService(new FLTConversationService());
  addService(new FLTConversationIdUtil());
  addService(new V2FLTUserService());
  addService(new FLTFriendService());
  addService(new FLTMessageCreator());
  addService(new V2FLTSettingsService());
  addService(new V2FLTTeamService());
  addService(new FLTSubscriptionService());
  addService(new FLTSignallingService());
  addService(new FLTLocalConversationService());
  addService(new FLTChatroomMessageCreator());
  addService(new FLTChatroomClient());
  addService(new FLTChatroomQueueService());
}

void NimCore::cleanService() {
  m_services.clear();
  addService(new FLTInitializeService());
}

void NimCore::addService(FLTService* service) { m_services[service->getServiceName()] = service; }

FLTService* NimCore::getService(const std::string& serviceName) const {
  auto service = m_services.find(serviceName);
  if (m_services.end() == service) {
    return nullptr;
  }

  return service->second;
}

FLTLoginService* NimCore::getFLTLoginService() const {
  return dynamic_cast<FLTLoginService*>(getService("AuthService"));
}

FLTMessageService* NimCore::getFLTMessageService() const {
  return dynamic_cast<FLTMessageService*>(getService("MessageService"));
}

void NimCore::setAppkey(const std::string& appkey) { m_appKey = appkey; }

std::string NimCore::getAppkey() const { return m_appKey; }

void NimCore::setLogDir(const std::string& logDir) { m_logDir = logDir; }
std::string NimCore::getLogDir() const { return m_logDir; }

std::string NimCore::getAccountId() const {
  auto fLTLoginService = getFLTLoginService();
  // todo getlogin account
  return "";
}

void NimCore::setMethodChannel(void* pChannel) { m_methodChannel->setMethodChannel(pChannel); }

void NimCore::invokeMethod(const std::string& eventName, const flutter::EncodableMap& arguments) {
  m_methodChannel->invokeMethod(eventName, arguments);
}

void NimCore::invokeMethod(const std::string& eventName, const flutter::EncodableMap& arguments,
                           const InvokeMehtodCallback& callback) {
  m_methodChannel->invokeMethod(eventName, arguments, callback);
}

void NimCore::onMethodCall(const std::string& methodName, const flutter::EncodableMap& arguments,
                           const NimResultCallback& resultCallback) {
  // std::cout << "NimCore::onMethodCall methodName: " << methodName << std::endl;
  auto serviceName_iter = arguments.find(flutter::EncodableValue("serviceName"));
  if (serviceName_iter != arguments.end() && !serviceName_iter->second.IsNull()) {
    std::string serviceName = std::get<std::string>(serviceName_iter->second);
    auto* service = getService(serviceName);
    if (service) {
      std::shared_ptr<MockMethodResult> mockResult =
          std::make_shared<MockMethodResult>(serviceName, methodName, resultCallback);
      //      YXLOG_API(Info) << "mn: " << methodName
      //                      << ", args: " <<
      //                      Convert::getInstance()->getStringFormMapForLog(&arguments)
      //                      << YXLOGEnd;
      service->onMethodCalled(methodName, &arguments, mockResult);
      return;
    }
  } else {
    //    YXLOG_API(Warn) << "sn not found, mn: " << methodName << YXLOGEnd;
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
MockMethodResult::MockMethodResult(const std::string serviceName, const std::string methodName,
                                   const NimResultCallback& resultCallback)
    : m_serviceName(serviceName), m_methodName(methodName), m_resultCallback(resultCallback) {}

void MockMethodResult::ErrorInternal(const std::string& error_code,
                                     const std::string& error_message,
                                     const flutter::EncodableValue* details) {
  //  YXLOG_API(Warn) << "cb error, sn: " << m_serviceName << ", mn: " << m_methodName
  //                  << ", error_code: " << error_code << ", error_msg: " << error_message
  //                  << ", details: " << getStringFormEncodableValue(details) << YXLOGEnd;
  if (m_resultCallback) m_resultCallback(details, false);
}

void MockMethodResult::NotImplementedInternal() {
  //  YXLOG_API(Warn) << "cb notImplemented, sn: " << m_serviceName << ", mn: " << m_methodName
  //                  << YXLOGEnd;
  if (m_resultCallback) m_resultCallback(nullptr, true);
}

void MockMethodResult::SuccessInternal(const flutter::EncodableValue* result) {
  std::string strLog;
  strLog.append("cb succ, sn: ")
      .append(m_serviceName)
      .append(", mn: ")
      .append(m_methodName)
      .append(", result: ")
      .append(getStringFormEncodableValue(result));
  std::list<std::string> logList;
  Convert::getInstance()->getLogList(strLog, logList);
  for (auto& it : logList) {
    //    YXLOG_API(Info) << it << YXLOGEnd;
  }

  if (m_resultCallback) m_resultCallback(result, false);
}

std::string MockMethodResult::getStringFormEncodableValue(
    const flutter::EncodableValue* value) const {
  if (!value) {
    return "";
  }

  std::string result;
  if (auto it = std::get_if<bool>(value); it) {
    result = *it ? "true" : "false";
  } else if (auto it1 = std::get_if<int32_t>(value); it1) {
    result = std::to_string(*it1);
  } else if (auto it2 = std::get_if<int64_t>(value); it2) {
    result = std::to_string(*it2);
  } else if (auto it3 = std::get_if<double>(value); it3) {
    result = std::to_string(*it3);
  } else if (auto it4 = std::get_if<std::string>(value); it4) {
    result = *it4;
  } else if (auto it5 = std::get_if<std::vector<uint8_t>>(value); it5) {
    result.append("[");
    bool bFirst = true;
    for (auto& it5Tmp : *it5) {
      if (!bFirst) {
        result.append("，");
      }
      result.append(std::to_string(it5Tmp));
      bFirst = false;
    }
    result.append("]");
  } else if (auto it6 = std::get_if<std::vector<int32_t>>(value); it6) {
    result.append("[");
    bool bFirst = true;
    for (auto& it6Tmp : *it6) {
      if (!bFirst) {
        result.append("，");
      }
      result.append(std::to_string(it6Tmp));
      bFirst = false;
    }
    result.append("]");
  } else if (auto it7 = std::get_if<std::vector<int64_t>>(value); it7) {
    result.append("[");
    bool bFirst = true;
    for (auto& it7Tmp : *it7) {
      if (!bFirst) {
        result.append("，");
      }
      result.append(std::to_string(it7Tmp));
      bFirst = false;
    }
    result.append("]");
  } else if (auto it8 = std::get_if<std::vector<double>>(value); it8) {
    result.append("[");
    bool bFirst = true;
    for (auto& it8Tmp : *it8) {
      if (!bFirst) {
        result.append("，");
      }
      result.append(std::to_string(it8Tmp));
      bFirst = false;
    }
    result.append("]");
  } else if (auto it9 = std::get_if<EncodableList>(value); it9) {
    result = Convert::getInstance()->getStringFormListForLog(it9);
  } else if (auto it10 = std::get_if<EncodableMap>(value); it10) {
    result = Convert::getInstance()->getStringFormMapForLog(it10);
  }

  return result;
}
