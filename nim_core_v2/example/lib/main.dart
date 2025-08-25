// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nim_core_v2/nim_core.dart';
import 'package:path_provider/path_provider.dart';

import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

import 'package:yunxin_alog/yunxin_alog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // For Publish Use
  static const appKey = 'Your_App_Key';
  static const account = 'Account_ID';
  static const token = 'Account_Token';
  static const friendAccount = 'Friend_Account_ID';
  static const chatroomId1 = '123456789';

  static const teamId = '35079835747';

  V2NIMChatroomClient? chatroomClient;

  final subsriptions = <StreamSubscription>[];

  final chatroomSubsriptions = <StreamSubscription>[];

  Uint8List? _deviceToken;

  void updateAPNsToken() {
    if (Platform.isIOS && _deviceToken != null) {
      NimCore.instance.apnsService.updateApnsToken(_deviceToken!);
    }
  }

  String loginListener = "";

  TextEditingController accountEditingController =
      TextEditingController(text: account);

  TextEditingController passwordEditingController =
      TextEditingController(text: token);

  TextEditingController providerToken = TextEditingController();

  TextEditingController providerExtension = TextEditingController();

  TextEditingController providerTimeout = TextEditingController();

  TextEditingController reConnectEditingController = TextEditingController();

  //动态token
  String syncToken = "";

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      MethodChannel('com.netease.NIM.demo/settings')
          .setMethodCallHandler((call) async {
        if (call.method == 'updateAPNsToken') {
          print('update APNs token');
          _deviceToken = call.arguments as Uint8List;
        }
        return null;
      });
      _copyResources();
    }

    subsriptions
        .add(NimCore.instance.loginService.onConnectFailed.listen((event) {
      print('LoginService##onConnectFailed: ${event.toJson()}');
      setState(() {
        loginListener = loginListener +
            '\n LoginService##onConnectFailed: ${event.toJson()}';
      });
    }));

    subsriptions
        .add(NimCore.instance.loginService.onDisconnected.listen((event) {
      print('LoginService##onDisconnected: ${event.toJson()}');
      setState(() {
        loginListener = loginListener +
            '\n LoginService##onDisconnected: ${event.toJson()}';
      });
    }));

    subsriptions
        .add(NimCore.instance.loginService.onLoginFailed.listen((event) {
      print('LoginService##onLoginFailed: ${event.toJson()}');
      setState(() {
        loginListener =
            loginListener + '\n LoginService##onLoginFailed: ${event.toJson()}';
      });
    }));

    subsriptions
        .add(NimCore.instance.conversationService.onSyncFailed.listen((e) {
      print('conversationService##onSyncFailed: ');
      setState(() {
        loginListener =
            loginListener + '\n conversationService##onSyncFailed: ';
      });
    }));

    subsriptions.add(NimCore.instance.teamService.onSyncFailed.listen((e) {
      print('teamService##onSyncFailed: ');
      setState(() {
        loginListener = loginListener + '\n teamService##onSyncFailed: ';
      });
    }));

    _doInitializeSDK();
  }

  void _doInitializeSDK() async {
    late NIMSDKOptions options;
    if (kIsWeb) {
      var base = NIMInitializeOptions(
        appkey: appKey,
        apiVersion: 'v2',
        debugLevel: 'debug',
      );
      options = NIMWebSDKOptions(
        appKey: appKey,
        initializeOptions: base,
      );
    } else if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      options = NIMAndroidSDKOptions(
          appKey: appKey,
          enableUserInfoProvider: true,
          enableMessageNotifierCustomization: true,
          shouldSyncStickTopSessionInfos: true,
          sdkRootDir:
              directory != null ? '${directory.path}/NIMFlutter' : null);
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      options = NIMIOSSDKOptions(
        appKey: appKey,
        shouldSyncStickTopSessionInfos: true,
        sdkRootDir: '${directory.path}/NIMFlutter',
        apnsCername: 'ENTERPRISE',
        pkCername: 'DEMO_PUSH_KIT',
      );
    } else if (Platform.isMacOS || Platform.isWindows) {
      NIMBasicOption basicOption = NIMBasicOption(
        enableCloudConversation: true
      );
      options = NIMPCSDKOptions(basicOption: basicOption, appKey: appKey);
    } else if (kIsWeb) {
      var base = NIMInitializeOptions(
        appkey: appKey,
      );
      options = NIMWebSDKOptions(
        appKey: appKey,
        initializeOptions: base,
      );
    } else {
      options = NIMOHOSSDKOptions(
        appKey: appKey,
      );
    }
    NimCore.instance.initialize(options).then((value) async {
      print('initialize result: $value');
    });
  }

  Future<String> getTokenFromServer(String account) async {
    var requestBody = {"appkey": appKey, "accid": account};

    var header = <String, String>{
      'content-type': 'application/x-www-form-urlencoded'
    };

    var url = Uri.parse(
        "http://imtest.netease.im/nimserver/god/mockDynamicToken.action");
    var response = await http.post(url, headers: header, body: requestBody);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      int code = responseData["code"];
      if (code != 200) {
        return "";
      }
      String token = responseData["data"];
      return token;
    } else {
      return "";
    }
  }

  Future<dynamic> createImgMsg() async {
    html.File? imageObj;
    String imageUrl =
        'https://img2.baidu.com/it/u=1008561530,2313586183&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1730';
    http.Response response = await http.get(Uri.parse(imageUrl));
    var blob = html.Blob([response.bodyBytes], 'image/jpeg', 'native');
    imageObj = html.File([blob], 'image.jpg');

    return MessageCreator.createImageMessage(
      '',
      'name',
      '',
      40,
      40,
      imageObj: imageObj,
    );
  }

  @override
  void dispose() {
    subsriptions.forEach((subsription) {
      subsription.cancel();
    });
    super.dispose();
  }

  void loginNormal() async {
    var options = NIMLoginOption();

    NimCore.instance.loginService.loginExtensionProvider =
        (String accountId) async {
      print('dart loginExtensionProvider');
      return "abd/$accountId";
    };

    final loginResult = await NimCore.instance.loginService.login(
        accountEditingController.text, passwordEditingController.text, options);
    print('login result: $loginResult');
  }

  void loginSync() async {
    var options = NIMLoginOption();

    options.authType = NIMLoginAuthType.authTypeDynamicToken;

    NimCore.instance.loginService.tokenProvider = (String accountId) async {
      print('login sync token : $accountId');
      return providerToken.text;
    };

    NimCore.instance.loginService.loginExtensionProvider =
        (String accountId) async {
      print('dart loginExtensionProvider');
      return providerExtension.text;
    };

    NimCore.instance.loginService.setReconnectDelayProvider((int time) async {
      print('dart setReconnectDelayProvider');
      return int.parse(providerTimeout.text);
    });

    final loginResult = await NimCore.instance.loginService.login(
        accountEditingController.text, passwordEditingController.text, options);
    print('login syncToken result: $loginResult');
  }

  ///发送文本消息
  void sendP2PTextMessage() async {
    final message =
        (await MessageCreator.createTextMessage('P2p text test message')).data;
    final conversationId = (await NimCore.instance.conversationIdUtil
            .p2pConversationId(friendAccount))
        .data!;
    if (message != null) {
      message.pushConfig = NIMMessagePushConfig(forcePush: true);
      final sendMessageResult = await NimCore.instance.messageService
          .sendMessage(message: message, conversationId: conversationId);
      if (sendMessageResult.isSuccess) {
        print(
            'fdsfsendMessage result: ${sendMessageResult.isSuccess} data ${sendMessageResult.data?.toJson()}');
      }
    }
  }

  void searchMessage() async {
    final conversationId = (await NimCore.instance.conversationIdUtil
            .p2pConversationId(friendAccount))
        .data;

    NimCore.instance.messageService
        .searchLocalMessages(NIMMessageSearchExParams(
            conversationId: conversationId,
            keywordList: ['P2p text'],
            limit: 5))
        .then((result) {
      print('Test searchLocalMessages result ${result.isSuccess}');
      if (result.isSuccess && result.data != null) {
        print('Test searchLocalMessages success');
        result.data?.items?.forEach((e) {
          e.messages?.forEach((message) {
            print('Test searchLocalMessages result = ${message.text}');
          });
        });
      }
    });
  }

  void setMessageFilter() {
    NimCore.instance.messageService.onReceiveMessages.listen((messages) {
      for (var message in messages) {
        print('Filter onReceiveMessages: ${message.toJson()}');
      }
    });

    NimCore.instance.messageService.setMessageFilter((message) async {
      print('setMessageFilter: ${message.toJson()}');
      if (message.messageType == NIMMessageType.notification) {
        return true;
      }
      return false;
    });
  }

  void searchMessageLocal() async {
    final conversationId =
        (await NimCore.instance.conversationIdUtil.teamConversationId(teamId))
            .data;
    final params = NIMMessageSearchExParams(
        conversationId: conversationId, keywordList: ['test'], limit: 10);
    NimCore.instance.messageService.searchLocalMessages(params).then((result) {
      print('searchMessageLocal message size = ${result.data?.count}');
    });
  }

  void searchMessageCloud() async {
    final conversationId =
        (await NimCore.instance.conversationIdUtil.teamConversationId(teamId))
            .data;
    final params = NIMMessageSearchExParams(
        pageToken: '',
        conversationId: conversationId,
        keywordList: ['test'],
        limit: 10);
    NimCore.instance.messageService
        .searchCloudMessagesEx(params)
        .then((result) {
      print('searchMessageCloud message size = ${result.data?.count}');
    });
  }

  //创建聊天室并进入
  void createChatroom() async {
    chatroomClient = (await V2NIMChatroomClient.newInstance()).data;
    print('chatroom: ${chatroomClient?.instanceId}');

    if (chatroomClient != null) {
      chatroomClient!.addChatroomClientListener();

      chatroomSubsriptions.addAll([
        chatroomClient!.onChatroomEntered.listen((event) {
          print('ChatroomClient:onChatroomEntered');
        }),
        chatroomClient!.onChatroomExited.listen((event) {
          print('ChatroomClient:onChatroomExited');
        })
      ]);

      final links = await NimCore.instance.loginService
          .getChatroomLinkAddress(chatroomId1);

      Alog.d(
          tag: 'ChatroomClient',
          content: 'enter result:${links?.isSuccess} data ${links?.data}');

      final enterParams = V2NIMChatroomEnterParams(
          authType: NIMLoginAuthType.authTypeDefault,
          accountId: account,
          token: token);

      chatroomClient!.linkProvider =
          (int instanceId, String roomId, String accountId) async {
        return links.data!;
      };

      final enterResult = await chatroomClient!.enter(chatroomId1, enterParams);

      print(
          'enter result:${enterResult?.isSuccess} data ${enterResult?.data?.toJson()}');

      Alog.d(
          tag: 'ChatroomClient',
          content:
              'enter result:${enterResult?.isSuccess} data ${enterResult?.data?.toJson()}');

      final chatroomInfoResult = await chatroomClient?.getChatroomInfo();

      print(
          'chatroomInfo result: ${chatroomInfoResult?.isSuccess} data ${chatroomInfoResult?.data?.toJson()}');

      Alog.d(
          tag: 'ChatroomClient',
          content:
              'chatroomInfo result: ${chatroomInfoResult?.isSuccess} data ${chatroomInfoResult?.data?.toJson()}');
    }
  }

  void getMessageList() async {
    String? conversationId =
        (await NimCore.instance.conversationIdUtil.teamConversationId(teamId))
            .data;
    NIMMessageListOption option =
        NIMMessageListOption(conversationId: conversationId);
    NimCore.instance.messageService
        .getMessageList(option: option)
        .then((result) {
      print(
          'getMessageList flutter result: ${result.isSuccess} data ${result.data?.length}');
    });
  }

  //添加监听
  void chatroomServiceListener() async {
    final addresult =
        await chatroomClient?.getChatroomService().addChatroomListener();

    chatroomSubsriptions.addAll([
      chatroomClient!.getChatroomService().onReceiveMessages.listen((event) {
        print('getChatroomService:onReceiveMessages');
      }),
      chatroomClient!.getChatroomService().onSendMessage.listen((event) {
        print('getChatroomService:onSendMessage ${event.message?.toJson()}');
      }),
      chatroomClient!
          .getChatroomService()
          .onSendMessageProgress
          .listen((event) {
        print(
            'getChatroomService:onSendMessageProgress  ${event.messageClientId} process ${event.progress}');
      }),
    ]);
  }

  void sendChatroomTextMessage() async {
    final message = (await V2NIMChatroomMessageCreator.createTextMessage(
            'test text chatroom message'))
        .data;

    final chatroomService = chatroomClient?.getChatroomService();

    if (message != null) {
      V2NIMSendChatroomMessageParams params = V2NIMSendChatroomMessageParams();
      final messageSender = await chatroomService?.sendMessage(message, params);
      print(
          'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
      Alog.d(
          tag: 'ChatroomService',
          content:
              'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
    }
  }

  void sendChatroomVideoMessage() async {
    final videoPath = Platform.isAndroid
        ? (await getExternalStorageDirectory())!.path + "/test.mp4"
        : (await getApplicationDocumentsDirectory()).path + "/test.mp4";

    if (!File(videoPath).existsSync()) {
      print('File $videoPath 不存在');
    }

    final message = (await V2NIMChatroomMessageCreator.createVideoMessage(
            videoPath,
            duration: 70000,
            width: 102,
            height: 150))
        .data;

    final chatroomService = chatroomClient?.getChatroomService();

    if (message != null) {
      V2NIMSendChatroomMessageParams params = V2NIMSendChatroomMessageParams();
      final messageSender = await chatroomService?.sendMessage(message, params);
      print(
          'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
      Alog.d(
          tag: 'ChatroomService',
          content:
              'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
    }
  }

  void sendChatroomImageMessage() async {
    final imagePath = Platform.isAndroid
        ? (await getExternalStorageDirectory())!.path + "/test.jpg"
        : (await getApplicationDocumentsDirectory()).path + "/test.jpg";

    if (!File(imagePath).existsSync()) {
      print('File $imagePath 不存在');
    }

    final message = (await V2NIMChatroomMessageCreator.createImageMessage(
            imagePath,
            width: 0,
            height: 0))
        .data;

    final chatroomService = chatroomClient?.getChatroomService();

    if (message != null) {
      V2NIMSendChatroomMessageParams params = V2NIMSendChatroomMessageParams();
      final messageSender = await chatroomService?.sendMessage(message, params);
      print(
          'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
      Alog.d(
          tag: 'ChatroomService',
          content:
              'messageSender: ${messageSender?.isSuccess} data ${messageSender?.data?.toJson()}');
    }
  }

  void sendChatroomAudioMessage() async {
    final audioPath = Platform.isAndroid
        ? (await getExternalStorageDirectory())!.path + "/test.mp3"
        : (await getApplicationDocumentsDirectory()).path + "/test.mp3";

    if (!File(audioPath).existsSync()) {
      print('File $audioPath 不存在');
    }

    final message = (await V2NIMChatroomMessageCreator.createAudioMessage(
            audioPath,
            duration: 6000))
        .data;

    final chatroomService = chatroomClient?.getChatroomService();

    if (message != null) {
      V2NIMSendChatroomMessageParams params = V2NIMSendChatroomMessageParams();
      final audioMessageSender =
          await chatroomService?.sendMessage(message, params);
      print(
          'audioMessageSender: ${audioMessageSender?.isSuccess} data ${audioMessageSender?.data?.toJson()}');
      Alog.d(
          tag: 'ChatroomService',
          content:
              'audioMessageSender: ${audioMessageSender?.isSuccess} data ${audioMessageSender?.data?.toJson()}');
    }
  }

  // void getMessageList() async {
  //   final chatroomService = chatroomClient?.getChatroomService();
  //   if (chatroomService != null) {
  //     final option = V2NIMChatroomMessageListOption(limit: 2);
  //     final messageList = (await chatroomService.getMessageList(option));
  //     if (messageList.data != null) {
  //       messageList.data!.forEach((message) {
  //         print('messageList : ${message.toJson()}');
  //       });
  //     }
  //   }
  // }

  void addQueueListener() {
    final chatroomQueue = chatroomClient?.getChatroomQueueService();
    chatroomQueue?.addQueueListener();
    chatroomSubsriptions.addAll([
      chatroomQueue!.onChatroomQueueOffered.listen((event) {
        print('onChatroomQueueOffered: ${event.toJson()}');
      }),
      chatroomQueue.onChatroomQueuePolled.listen((event) {
        print('onChatroomQueuePolled: ${event.toJson()}');
      }),
      chatroomQueue.onChatroomQueueBatchUpdated.listen((event) {
        print('onChatroomQueueBatchUpdated: ${event.length}');
      })
    ]);
  }

  void queueOffer() async {
    final params = V2NIMChatroomQueueOfferParams(
        elementKey: 'testKey', elementValue: 'testValue');
    final chatroomQueue = chatroomClient?.getChatroomQueueService();
    final result = await chatroomQueue?.queueOffer(params);
    print('queueOffer result: ${result?.isSuccess} data ');
  }

  void queuePeek() async {
    final chatroomQueue = chatroomClient?.getChatroomQueueService();
    final result = await chatroomQueue?.queuePeek();
    print(
        'queuePeek result: ${result?.isSuccess} data ${result?.data?.toJson()}');
    final updateResult = await chatroomQueue?.queueBatchUpdate([result!.data!]);
    print('queueBatchUpdate result: ${updateResult?.isSuccess} data');
  }

  void queueInit() async {
    final chatroomQueue = chatroomClient?.getChatroomQueueService();
    final result = await chatroomQueue?.queueInit(3);
    print('queueInit result: ${result?.isSuccess} ');
  }

  void queueList() async {
    final chatroomQueue = chatroomClient?.getChatroomQueueService();
    final result = await chatroomQueue?.queueList();
    print(
        'queueList result: ${result?.isSuccess} data ${result?.data?.length}');
  }

  void _copyResources() async {
    // copy image
    var bytes = await rootBundle.load("resources/test.jpg");
    Directory? documentDir = await getApplicationDocumentsDirectory();
    File tempFile = new File("${documentDir?.path}/test.jpg");
    if (!tempFile.existsSync()) {
      tempFile.createSync();
    }
    tempFile.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    // copy mp3
    bytes = await rootBundle.load("resources/test.mp3");
    tempFile = new File("${documentDir?.path}/test.mp3");
    if (!tempFile.existsSync()) {
      tempFile.createSync();
    }
    tempFile.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    // copy mp4
    bytes = await rootBundle.load("resources/test.mp4");
    tempFile = new File("${documentDir?.path}/test.mp4");
    if (!tempFile.existsSync()) {
      tempFile.createSync();
    }
    tempFile.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text('登录回调'),
              Text(
                loginListener,
                maxLines: 6,
              ),
              Text('账号'),
              TextField(
                controller: accountEditingController,
              ),
              Text('token'),
              TextField(
                controller: passwordEditingController,
              ),
              Text('动态token'),
              TextField(
                controller: providerToken,
              ),
              Text('登录扩展'),
              TextField(
                controller: providerExtension,
              ),
              Text('登录重连延时回调'),
              TextField(
                controller: providerTimeout,
                keyboardType: TextInputType.number, // 弹出数字键盘
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly // 只允许输入数字
                ],
              ),
              TextButton(
                  onPressed: () {
                    loginNormal();
                  },
                  child: Text('普通登录')),
              TextButton(
                  onPressed: () {
                    sendP2PTextMessage();
                  },
                  child: Text('发送消息')),
              TextButton(
                  onPressed: () {
                    searchMessage();
                  },
                  child: Text('搜索消息')),
              TextButton(
                  onPressed: () {
                    searchMessageLocal();
                  },
                  child: Text('本地查询')),
              TextButton(
                  onPressed: () {
                    searchMessageCloud();
                  },
                  child: Text('云端查询')),
              // TextButton(
              //     onPressed: () {
              //       chatroomServiceListener();
              //     },
              //     child: Text('添加聊天室服务')),
              // TextButton(
              //     onPressed: () {
              //       addQueueListener();
              //     },
              //     child: Text('添加队列监听')),
              // TextButton(
              //     onPressed: () {
              //       queueInit();
              //     },
              //     child: Text('初始化队列')),
              // TextButton(
              //     onPressed: () {
              //       queueOffer();
              //     },
              //     child: Text('新增队列')),
              // TextButton(
              //     onPressed: () {
              //       queueList();
              //     },
              //     child: Text('拉取队列')),
              // TextButton(
              //     onPressed: () {
              //       queuePeek();
              //     },
              //     child: Text('更新队列')),
              // TextButton(
              //     onPressed: () {
              //       sendChatroomTextMessage();
              //     },
              //     child: Text('发送消息')),
              // TextButton(
              //     onPressed: () {
              //       sendChatroomImageMessage();
              //     },
              //     child: Text('发送图片消息')),
              // TextButton(
              //     onPressed: () {
              //       sendChatroomVideoMessage();
              //     },
              //     child: Text('发送视频消息')),
              // TextButton(
              //     onPressed: () {
              //       sendChatroomAudioMessage();
              //     },
              //     child: Text('发送语音消息')),
              // TextButton(
              //     onPressed: () {
              //       getMessageList();
              //     },
              //     child: Text('拉取消息')),
            ],
          ),
        ),
      ),
    );
  }
}
