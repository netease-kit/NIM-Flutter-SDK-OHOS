// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef FLTCONVERT_H
#define FLTCONVERT_H

#include <string>
#include <unordered_map>

#include "common/FLTService.h"
#include "common/utils/singleton.h"

class Convert {
 public:
  SINGLETONG(Convert)

  std::string getStringFormMapForLog(
      const flutter::EncodableMap* arguments) const;
  void getLogList(const std::string& strLog,
                  std::list<std::string>& listLog) const;
  std::string getStringFormListForLog(
      const flutter::EncodableList* arguments) const;

 private:
  Convert();
};

#endif  // FLTCONVERT_H
