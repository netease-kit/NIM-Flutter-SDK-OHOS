/*
 *
 *  * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 *  * Use of this source code is governed by a MIT license that can be
 *  * found in the LICENSE file.
 *
 *
 */
import {
  DatabaseOptions,
  DataReporterConfig,
  LogLevel,
  NIMHttpServiceConfig,
  NIMInitializeOptions,
  NIMLoginServiceConfig,
  NIMMessageServiceConfig,
  NIMPushServiceConfig,
  NIMServiceOptions,
  NIMStorageServiceConfig,
  V2NIMConversationConfig,
  V2NIMLocalConversationConfig,
  V2NIMProtocolFamily,
  V2NIMProvidedServiceType
} from '@nimsdk/base';
import { V2NIMConversationServiceImpl } from '@nimsdk/conversation';
import { V2NIMFriendServiceImpl } from '@nimsdk/friend';
import { V2NIMLocalConversationServiceImpl } from '@nimsdk/localconversation';
import { V2NIMClientAntispamUtil, V2NIMMessageServiceImpl } from '@nimsdk/message';
import { NIMSdk } from '@nimsdk/nim';
import { V2NIMSearchServiceImpl } from '@nimsdk/search';
import { V2NIMSignallingServiceImpl } from '@nimsdk/signalling';
import { V2NIMTeamServiceImpl } from '@nimsdk/team';
import { V2NIMUserServiceImpl } from '@nimsdk/user';
import { Any, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { NimCore } from '../NimCore';

@ObservedV2
export class FLTInitializeService extends FLTService {
  private serviceNameTag: string = "InitializeService";
  private isInitialize: boolean = false;

  _onInitializedSuccess() {
    this.isInitialize = true;
    NimCore.getInstance().onInitialized()
  }

  get serviceName(): string {
    return this.serviceNameTag;
  }

  get hasInitialize(): boolean {
    if (this.isInitialize) {
      return true;
    }
    if (NimCore.getInstance().nimInterface != null) {
      this.isInitialize = true;
      return true;
    }
    return this.isInitialize;
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    if (method == "initialize") {
      this.initializeService(args, result);
    } else if (method == "getInstance") {
      this.getInstance(args, result);
    } else if (method == "destroyInstance") {
      this.destroyInstance(args, result);
    } else if (method == "releaseDesktop") {
      this.destroy(args, result);
    } else {
      this.onErrorWithCode(result, -1, "has not implement")
    }
  }


  private initializeService(args: Map<string, Any>, result: MethodResult): void {
    // 初始化操作
    console.log('InitializeService initialized');
    let sdkVersion = "";
    if(args.get("extras") !== null && args.get("extras") !== undefined){
      let extras = args.get("extras") as Map<string,string | number>;
      if(extras.get("versionName") !== undefined && extras.get("versionName") !== null){
        sdkVersion = extras.get("versionName") as string
      }
    }
    let initializeOptions: NIMInitializeOptions = {
      appkey: args.get("appKey") as string,
      // 可选参数：日志级别，从Map获取并转换为LogLevel类型
      logLevel: args.has("logLevel")
        ? (args.get("logLevel") as LogLevel)
        : undefined,
      flutterSDKVersion:sdkVersion,
      // 可选参数：xhr连接超时时间
      xhrConnectTimeout: args.has("xhrConnectTimeout")
        ? (Number(args.get("xhrConnectTimeout")))
        : undefined,

      // 可选参数：socket长连接超时时间
      socketConnectTimeout: args.has("socketConnectTimeout")
        ? (Number(args.get("socketConnectTimeout")))
        : undefined,

      // 可选参数：是否输出SDK日志到控制台
      isOpenConsoleLog: args.has("isOpenConsoleLog")
        ? (args.get("isOpenConsoleLog") === 'true' || args.get("isOpenConsoleLog") === true)
        : undefined,

      // 可选参数：是否过滤输出到日志文件的信息
      isFilteringLog: args.has("isFilteringLog")
        ? (args.get("isFilteringLog") === 'true' || args.get("isFilteringLog") === true)
        : undefined
    };
    // 组装完整的服务配置选项
    let serviceOptions: NIMServiceOptions | undefined = undefined;
    if (args.get("serverOptions") !== null && args.get("serverOptions") !== undefined) {
      serviceOptions = this.convertToNIMServiceOptions(args.get("serverOptions") as Map<string, Any>)
    }

    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_TEAM,
      (core, serviceName, serviceConfig) => new V2NIMTeamServiceImpl(core, serviceName, serviceConfig))
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_CLIENT_ANTISPAM_UTIL,
      (core, serviceName, serviceConfig) => new V2NIMClientAntispamUtil(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_LOCAL_CONVERSATION,
      (core, serviceName, serviceConfig) => new V2NIMLocalConversationServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_CONVERSATION,
      (core, serviceName, serviceConfig) => new V2NIMConversationServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_MESSAGE,
      (core, serviceName, serviceConfig) => new V2NIMMessageServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_USER,
      (core, serviceName, serviceConfig) => new V2NIMUserServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_FRIEND,
      (core, serviceName, serviceConfig) => new V2NIMFriendServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_SIGNALLING,
      (core, serviceName, serviceConfig) => new V2NIMSignallingServiceImpl(core, serviceName, serviceConfig));
    NIMSdk.registerCustomServices(V2NIMProvidedServiceType.V2NIM_PROVIDED_SERVICE_SEARCH,
      (core, serviceName, serviceConfig) => new V2NIMSearchServiceImpl(core, serviceName, serviceConfig));

    try {
      NimCore.getInstance().nimInterface =
        NIMSdk.newInstance(NimCore.getInstance().context, initializeOptions, serviceOptions)
      this._onInitializedSuccess();
      this.onSuccess(result)
    } catch (e) {
      this.onError(result, e)
    }
  }

  private getInstance(args: Map<string, Any>, result: MethodResult): void {
    const instanceId = args.get("instanceId") as number;
    let nim = NIMSdk.getInstance(instanceId)
    if (nim) {
      NimCore.getInstance().nimInterface = nim
      this.onSuccess(result)
    } else {
      this.onErrorWithCode(result, -1, "instance not exit")
    }
  }

  private destroyInstance(args: Map<string, Any>, result: MethodResult): void {
    const instanceId = args.get("instanceId") as number;
    NIMSdk.destroyInstance(instanceId)
    this.onSuccess(result)
  }

  private destroy(args: Map<string, Any>, result: MethodResult): void {
    NIMSdk.destroy()
    this.isInitialize = false
    this.onSuccess(result)
  }

  private convertToNIMServiceOptions(args: Map<string, Any>): NIMServiceOptions {
    let loginServiceConfig: NIMLoginServiceConfig | undefined = undefined;
    if (args.get("loginServiceConfig") !== null && args.get("loginServiceConfig") !== undefined) {
      loginServiceConfig = this.convertToNIMLoginServiceConfig(args.get("loginServiceConfig") as Map<string, Any>)
    }


    // 补充本地会话配置（空接口，仅处理存在性）TODO
    let messageServiceConfig: NIMMessageServiceConfig | undefined = undefined;
    if (args.get("messageServiceConfig") !== null && args.get("messageServiceConfig") !== undefined) {
      const messageServiceMap: Map<string, Any> = args.get("messageServiceConfig") as Map<string, Any>;
      messageServiceConfig = {
        services: messageServiceMap.has("services") ? (messageServiceMap.get("services") as string []) : undefined
      };
    }

    let pushServiceConfig: NIMPushServiceConfig | undefined = undefined;
    if (args.get("pushServiceConfig") !== null && args.get("pushServiceConfig") !== undefined) {
      let pushMap: Map<string, Any> = args.get("pushServiceConfig") as Map<string, Any>
      if (pushMap.has("harmonyCertificateName")) {
        pushServiceConfig = {
          harmonyCertificateName: pushMap.get("harmonyCertificateName") as string | undefined
        }
      }
    }

    // 补充 HTTP 服务配置
    let httpServiceConfig: NIMHttpServiceConfig | undefined = undefined;
    if (args.get("httpServiceConfig") !== null && args.get("httpServiceConfig") !== undefined) {
      const httpMap: Map<string, Any> = args.get("httpServiceConfig") as Map<string, Any>;
      httpServiceConfig = {
        services: httpMap.has("services") ? (httpMap.get("services") as string []) : undefined,
        chunkUploadHost: httpMap.has("chunkUploadHost") ? (httpMap.get("chunkUploadHost") as string) : undefined,
        uploadReplaceFormat: httpMap.has("uploadReplaceFormat") ? (httpMap.get("uploadReplaceFormat") as string) :
          undefined
      };
    }
    // 补充数据库服务配置
    let databaseServiceConfig: DatabaseOptions | undefined = undefined;
    if (args.get("databaseServiceConfig") !== null && args.get("databaseServiceConfig") !== undefined) {
      const dbMap: Map<string, Any> = args.get("databaseServiceConfig") as Map<string, Any>;
      if (dbMap.has("appKey")) { // 确保必填项存在
        databaseServiceConfig = {
          appKey: dbMap.get("appKey") as string,
          securityLevel: dbMap.has("securityLevel") ? (dbMap.get("securityLevel") as number) : undefined,
          encrypt: dbMap.has("encrypt") ? (dbMap.get("encrypt") as boolean) : undefined,
          services: dbMap.has("services") ? (dbMap.get("services") as string []) : undefined
        };
      }
    }

    // 补充存储服务配置
    let storageServiceConfig: NIMStorageServiceConfig | undefined = undefined;
    if (args.get("storageServiceConfig") !== null && args.get("storageServiceConfig") !== undefined) {
      const storageMap: Map<string, Any> = args.get("storageServiceConfig") as Map<string, Any>;
      storageServiceConfig = {
        services: storageMap.has("services") ? (storageMap.get("services") as string []) : undefined,
        downloadHost: storageMap.has("downloadHost") ? (storageMap.get("downloadHost") as string) : undefined,
        downloadReplaceFormat: storageMap.has("downloadReplaceFormat") ?
          (storageMap.get("downloadReplaceFormat") as string) : undefined
      };
    }

    // 补充云端会话配置
    let conversationServiceConfig: V2NIMConversationConfig | undefined = undefined;
    if (args.get("conversationServiceConfig") !== null && args.get("conversationServiceConfig") !== undefined) {
      const conversationMap: Map<string, Any> = args.get("conversationServiceConfig") as Map<string, Any>;
      conversationServiceConfig = {
        services: conversationMap.has("services") ? (conversationMap.get("services") as string []) : undefined,
        loadHistoryConversationLimit: conversationMap.has("loadHistoryConversationLimit") ?
          (conversationMap.get("loadHistoryConversationLimit") as number) : undefined
      };
    }

    // 补充本地会话配置（空接口，仅处理存在性）
    let localConversationServiceConfig: V2NIMLocalConversationConfig | undefined = undefined;
    if (args.get("localConversationServiceConfig") !== null &&
      args.get("localConversationServiceConfig") !== undefined) {
      const localConversationMap: Map<string, Any> = args.get("localConversationServiceConfig") as Map<string, Any>;
      localConversationServiceConfig = {
        services: localConversationMap.has("services") ? (localConversationMap.get("services") as string []) : undefined
      };
    }

    // 补充数据上报配置
    let dataReporterConfig: DataReporterConfig | undefined = undefined;
    if (args.get("dataReporterConfig") !== null && args.get("dataReporterConfig") !== undefined) {
      const reporterMap: Map<string, Any> = args.get("dataReporterConfig") as Map<string, Any>;
      // 确保必填字段存在
      if (reporterMap.has("isCloseDataReporter")) {
        dataReporterConfig = {
          services: reporterMap.has("services") ? (reporterMap.get("services") as string []) : undefined,
          isCloseDataReporter: reporterMap.get("isCloseDataReporter") as boolean,
          dataReporterAddress: reporterMap.has("dataReporterAddress") ?
            (reporterMap.get("dataReporterAddress") as string) : undefined
        };
      }
    }

    // 组装完整的服务配置选项
    return {
      loginServiceConfig: loginServiceConfig,
      messageServiceConfig: messageServiceConfig,
      pushServiceConfig: pushServiceConfig,
      httpServiceConfig: httpServiceConfig,
      databaseServiceConfig: databaseServiceConfig,
      storageServiceConfig: storageServiceConfig,
      conversationServiceConfig: conversationServiceConfig,
      localConversationServiceConfig: localConversationServiceConfig,
      dataReporterConfig: dataReporterConfig
    };
  }

  /**
   * 将Map<string, Any>转换为NIMLoginServiceConfig接口实例（优化类型断言）
   * @param map 包含登录服务配置的Map，可为null或undefined
   * @returns 转换后的NIMLoginServiceConfig实例
   */
  private convertToNIMLoginServiceConfig(map: Map<string, Any> | undefined): NIMLoginServiceConfig {
    // 初始化所有字段为默认值（可选字段默认为undefined）
    let lbsUrls: string[] | undefined = undefined;
    let linkUrl: string | undefined = undefined;
    let customClientType: number | undefined = undefined;
    let customTag: string | undefined = undefined;
    let isHttps: boolean | undefined = undefined;
    let supportProtocolFamily: V2NIMProtocolFamily | undefined = undefined;

    if (map) {
      // 处理lbsUrls（字符串数组）- 明确类型断言为unknown[]避免编译器报错
      const lbsUrlsRaw = map.get('lbsUrls') as object;
      if (lbsUrlsRaw !== null && lbsUrlsRaw !== undefined && Array.isArray(lbsUrlsRaw)) {
        // 过滤数组中的非字符串元素
        let urlArray = lbsUrlsRaw as string[];
        if (urlArray.length > 0) {
          lbsUrls = urlArray
        }
      }

      // 处理linkUrl（字符串）- 明确类型断言
      const linkUrlRaw = map.get('linkUrl') as object;
      if (typeof linkUrlRaw === 'string') {
        linkUrl = linkUrlRaw;
      }

      // 处理customClientType（大于0的数字）- 明确类型断言
      const customClientTypeRaw = map.get('customClientType') as object;
      if (typeof customClientTypeRaw === 'number' && customClientTypeRaw > 0) {
        customClientType = customClientTypeRaw;
      }

      // 处理customTag（最大32个字符的字符串）- 明确类型断言
      const customTagRaw = map.get('customTag') as object;
      if (typeof customTagRaw === 'string') {
        customTag = customTagRaw;
      }

      // 处理isHttps（布尔值）- 明确类型断言
      const isHttpsRaw = map.get('isHttps') as object;
      if (typeof isHttpsRaw === 'boolean') {
        isHttps = isHttpsRaw;
      }

      // 处理supportProtocolFamily（枚举类型）- 明确类型断言
      const protocolFamilyRaw = map.get('supportProtocolFamily') as number | undefined;
      if (typeof protocolFamilyRaw === 'number') {
        // 验证是否为有效的枚举值
        const validValues = Object.values(V2NIMProtocolFamily)
          .filter(value => typeof value === 'number') as V2NIMProtocolFamily[];

        if (validValues.includes(protocolFamilyRaw)) {
          supportProtocolFamily = protocolFamilyRaw;
        }
      }
    }
    // 构建并返回配置对象
    return {
      lbsUrls: lbsUrls,
      linkUrl: linkUrl,
      customClientType: customClientType,
      customTag: customTag,
      isHttps: isHttps,
      supportProtocolFamily: supportProtocolFamily
    };
  }
}