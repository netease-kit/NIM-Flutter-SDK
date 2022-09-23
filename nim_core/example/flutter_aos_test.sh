#!/usr/bin/env bash
# Copyright (c) 2022 NetEase, Inc. All rights reserved.
# Use of this source code is governed by a MIT license that can be
# found in the LICENSE file.

applicationName=$1
platformName=$2
version=$3
deviceId=$4
host="10.219.25.29"
set -x
## 主要用于flutter工程进行接口自动化和界面自动化
echo "==================start"

#
#selectPartNameList=[\"part01\"]
selectPartNameList="all"
branch="release/integration_case"

## 执行方式 ===========
# sh flutter_aos_test.sh nimflutter flutter 1.0.0 074214547102774
parse_json(){
echo "${1//\"/}" | sed "s/.*$2:\([^,}]*\).*/\1/"
}
dispatchDevice() {
result=$(curl -X "POST" "http://${host}:9000/device?path=dispatch" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d $'{
  "platform":"'${platformName}'",
  "selectPartNameList": '${selectPartNameList}',
  "version": "'${version}'",
  "branch": "'${branch}'",
  "deviceIdMap":  {
    "any": "'${deviceId}'"
  },
  "applicationName": "'${applicationName}'"
}')

  value=$(parse_json "$result" "currentIndex")
  echo "$value"
}

dispatchDevice
pwd


#flutter clean
#flutter pub get
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/main_test.dart  --keep-app-running
