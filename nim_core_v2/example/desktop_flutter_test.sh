#!/usr/bin/env bash
# Copyright (c) 2022 NetEase, Inc. All rights reserved.
# Use of this source code is governed by a MIT license that can be
# found in the LICENSE file.

#set -x

applicationName="nimflutter"
platformName="flutter"
version="1.0.0"
host="10.219.25.29"
#selectPartNameList=[\"part01\"]
selectPartNameList=[]
branch=$1

if [ -z "$branch" ] || [ "$branch" == "" ]; then
    branch="release/integration_case"
fi

case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*)
    export platform=linux
    ;;
  darwin*)
    export platform=macos
    export deviceId="$HOSTNAME"
    ;;
  msys* | mingw*)
    export platform=windows
    export deviceId="$HOSTNAME".cn.net.ntes
    ;;
  *)
    export platform=notset
    export deviceId=notset
    ;;
esac


shellFolder=$(cd "$(dirname "$0")";pwd)
cd "$shellFolder"

userName=$(id -u -nr)
if [ "$platform" == "windows" ] && ([ "$userName" == "yunxin" ]); then
    deviceId="$HOSTNAME"
fi

echo curPath: `pwd`
echo userName: "$userName"
echo platform: "$platform"
echo deviceId: "$deviceId"
echo branch: "$branch"

## 执行方式 ===========
# sh flutter_aos_test.sh release/integration_case

parse_json(){
echo "${1//\"/}" | sed "s/.*${platformName}:\([^,}]*\).*/\1/"
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
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/main_test.dart --no-keep-app-running -d "$platform"
