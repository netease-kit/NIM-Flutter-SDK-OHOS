// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:nim_core_v2_platform_interface/nim_core_v2_platform_interface.dart';
import 'package:universal_html/html.dart' as html;

class MethodChannelStorageService extends StorageServicePlatform {
  /// 文件上传进度
  final _uploadFileProgress =
      StreamController<NIMUploadFileProgress>.broadcast();

  /// 文件下载进度
  final _downloadFileProgress =
      StreamController<NIMDownloadFileProgress>.broadcast();

  /// 消息附件下载进度
  final _messageAttachmentDownloadProgress =
      StreamController<NIMDownloadMessageAttachmentProgress>.broadcast();

  @override
  Future onEvent(String method, arguments) {
    switch (method) {
      case 'onFileDownloadProgress':
        assert(arguments is Map);
        _downloadFileProgress.add(NIMDownloadFileProgress.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onFileUploadProgress':
        assert(arguments is Map);
        _uploadFileProgress.add(NIMUploadFileProgress.fromJson(
            Map<String, dynamic>.from(arguments)));
        break;
      case 'onMessageAttachmentDownloadProgress':
        assert(arguments is Map);
        _messageAttachmentDownloadProgress.add(
            NIMDownloadMessageAttachmentProgress.fromJson(
                Map<String, dynamic>.from(arguments)));
        break;
      default:
        throw UnimplementedError();
    }
    return Future.value();
  }

  @override
  String get serviceName => 'StorageService';

  @override
  Future<NIMResult<NIMStorageScene>> addCustomStorageScene(
      String sceneName, int expireTime,
      {int? instanceId}) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'addCustomStorageScene',
        arguments: {
          'sceneName': sceneName,
          'expireTime': expireTime,
          'instanceId': instanceId,
        },
      ),
      convert: (map) => NIMStorageScene.fromJson(map),
    );
  }

  @override
  Future<NIMResult<void>> cancelUploadFile(NIMUploadFileTask fileTask,
      {int? instanceId}) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'cancelUploadFile',
        arguments: {
          'fileTask': fileTask.toJson(),
          'instanceId': instanceId,
        },
      ),
    );
  }

  @override
  Future<NIMResult<NIMUploadFileTask>> createUploadFileTask(
      NIMUploadFileParams fileParams,
      {html.File? fileObj,
      int? instanceId}) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'createUploadFileTask',
        arguments: {
          'fileParams': fileParams.toJson(),
          'fileObj': fileObj,
          'instanceId': instanceId,
        },
      ),
      convert: (map) => NIMUploadFileTask.fromJson(map),
    );
  }

  @override
  Future<NIMResult<String>> downloadAttachment(
      NIMDownloadMessageAttachmentParams downloadParam,
      {int? instanceId}) async {
    return NIMResult.fromMap(await invokeMethod(
      'downloadAttachment',
      arguments: {
        'downloadParam': downloadParam.toJson(),
        'instanceId': instanceId,
      },
    ));
  }

  @override
  Future<NIMResult<String>> downloadFile(String url, String filePath,
      {int? instanceId}) async {
    return NIMResult.fromMap(await invokeMethod(
      'downloadFile',
      arguments: {
        'url': url,
        'filePath': filePath,
        'instanceId': instanceId,
      },
    ));
  }

  @override
  Future<NIMResult<NIMGetMediaResourceInfoResult>> getImageThumbUrl(
      NIMMessageAttachment attachment, NIMSize thumbSize,
      {int? instanceId}) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'getImageThumbUrl',
        arguments: {
          'attachment': attachment.toJson(),
          'thumbSize': thumbSize.toJson(),
          'instanceId': instanceId,
        },
      ),
      convert: (map) => NIMGetMediaResourceInfoResult.fromJson(
          Map<String, dynamic>.from(map)),
    );
  }

  @override
  Future<NIMResult<List<NIMStorageScene>>> getStorageSceneList(
      {int? instanceId}) async {
    return NIMResult.fromMap(
      await invokeMethod('getStorageSceneList', arguments: {
        'instanceId': instanceId,
      }),
      convert: (map) {
        return (map['sceneList'] as List<dynamic>?)
            ?.map((e) => NIMStorageScene.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      },
    );
  }

  @override
  Future<NIMResult<NIMGetMediaResourceInfoResult>> getVideoCoverUrl(
      NIMMessageAttachment attachment, NIMSize thumbSize,
      {int? instanceId}) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'getVideoCoverUrl',
        arguments: {
          'attachment': attachment.toJson(),
          'thumbSize': thumbSize.toJson(),
          'instanceId': instanceId,
        },
      ),
      convert: (map) => NIMGetMediaResourceInfoResult.fromJson(
          Map<String, dynamic>.from(map)),
    );
  }

  @override
  Future<NIMResult<String>> shortUrlToLong(String url,
      {int? instanceId}) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'shortUrlToLong',
        arguments: {
          'url': url,
          'instanceId': instanceId,
        },
      ),
    );
  }

  @override
  Future<NIMResult<String>> uploadFile(NIMUploadFileTask fileTask,
      {html.File? fileObj, int? instanceId}) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'uploadFile',
        arguments: {
          'fileTask': fileTask.toJson(),
          'fileObj': fileObj,
          'instanceId': instanceId,
        },
      ),
    );
  }

  /// 生成图片缩略链接
  /// [url] 图片原始链接
  /// [thumbSize] 缩放的尺寸
  ///  返回图片缩略链接
  @override
  Future<NIMResult<String>> imageThumbUrl(String url, int thumbSize,
      {int? instanceId}) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'imageThumbUrl',
        arguments: {
          'url': url,
          'thumbSize': thumbSize,
          'instanceId': instanceId,
        },
      ),
    );
  }

  /// 生成视频封面图链接
  ///  [url] 视频原始链接
  ///  [offset] 从第几秒开始截
  ///  [thumbSize] 封面尺寸，单位像素（仅对PC有效）
  ///  [type] 封面类型，如 png，jpeg（仅对PC有效）
  ///  返回视频封面图链接
  Future<NIMResult<String>> videoCoverUrl(
      String url, int offset, int? thumbSize, String? type,
      {int? instanceId}) async {
    return NIMResult.fromMap(
      await invokeMethod(
        'videoCoverUrl',
        arguments: {
          'url': url,
          'offset': offset,
          'thumbSize': thumbSize,
          'type': type,
          'instanceId': instanceId,
        },
      ),
    );
  }

  @override
  Stream<NIMDownloadFileProgress> get onFileDownloadProgress =>
      _downloadFileProgress.stream;

  @override
  Stream<NIMUploadFileProgress> get onFileUploadProgress =>
      _uploadFileProgress.stream;

  @override
  Stream<NIMDownloadMessageAttachmentProgress>
      get onMessageAttachmentDownloadProgress =>
          _messageAttachmentDownloadProgress.stream;
}
