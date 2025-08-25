// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import "FLTLog.h"
#import <YXAlog_iOS/YXAlog.h>

#if __has_include(<nim_core_v2/nim_core_v2-Swift.h>)
#import <nim_core_v2/nim_core_v2-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "nim_core_v2-Swift.h"
#endif

static NSString *FILE_PREFIX = @"xkit";

@interface FLTLog ()

@property(nonatomic, strong) FLTLogOptions *opt;

@end

@implementation FLTLog

+ (FLTLog *)setUp:(FLTLogOptions *)options {
  FLTLog *log = [[FLTLog alloc] init];
  log.opt = options;

  YXAlogOptions *opt = [YXAlogOptions new];
  opt.path = [NimPathUtils getDirectoryForDocumentsWithDir:@"NIMSDK/Logs/extra_log/XKitLog"];
  // ALOG的LEVEL默认开到最大，通过每个XKitLog对象的XKitLogOptions来控制打印等级
  opt.level = YXAlogLevelVerbose;
  opt.moduleName = options.moduleName.length ? options.moduleName : @"XKit";
  opt.filePrefix = FILE_PREFIX;
  [YXAlog.shared setupWithOptions:opt];

  return log;
}

- (void)apiLog:(NSString *)className desc:(NSString *)desc {
  [YXAlog.shared logWithLevel:YXAlogLevelInfo
                   moduleName:self.opt.moduleName
                          tag:className
                         type:YXAlogTypeApi
                         line:0
                         desc:[self desensitize:desc]];
}

- (void)infoLog:(NSString *)className desc:(NSString *)desc {
  if (self.opt.level < YXAlogLevelWarn) {
    [YXAlog.shared logWithLevel:YXAlogLevelInfo
                     moduleName:self.opt.moduleName
                            tag:className
                           type:YXAlogTypeNormal
                           line:0
                           desc:[self desensitize:desc]];
  }
}

- (void)warnLog:(NSString *)className desc:(NSString *)desc {
  if (self.opt.level < YXAlogLevelError) {
    [YXAlog.shared logWithLevel:YXAlogLevelWarn
                     moduleName:self.opt.moduleName
                            tag:className
                           type:YXAlogTypeNormal
                           line:0
                           desc:[self desensitize:desc]];
  }
}

- (void)errorLog:(NSString *)className desc:(NSString *)desc {
  if (self.opt.level < YXAlogLevelTest) {
    [YXAlog.shared logWithLevel:YXAlogLevelError
                     moduleName:self.opt.moduleName
                            tag:className
                           type:YXAlogTypeNormal
                           line:0
                           desc:[self desensitize:desc]];
  }
}

// 对日志内容进行脱敏
- (NSString *)desensitize:(NSString *)desc {
  NSString *target = desc;
  for (NSString *sensitive in self.opt.sensitives) {
    target = [NimStringUtils desensitizeWithString:target sensitive:sensitive];
  }
  return target;
}

@end
