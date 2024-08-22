# Copyright (c) 2022 NetEase, Inc. All rights reserved.
# Use of this source code is governed by a MIT license that can be
# found in the LICENSE file.

set -e
set +x

echo "Pack meeting evn start"
ENV=$1
echo "ENV: ${ENV}"

PROJECT_PATH=$(pwd)
echo "$PROJECT_PATH"
cd "$PROJECT_PATH"

CONFIG_PROPERTIES="${PROJECT_PATH}/assets/config.properties"
echo "${CONFIG_PROPERTIES}"

packOnline(){
  echo "Config sdk online address";
  sed -i "" "s#^ENV=.*#ENV=ONLINE#g" "$CONFIG_PROPERTIES"
}

packTest(){
  echo "Config sdk test address";
  sed -i "" "s#^ENV=.*#ENV=TEST#g" "$CONFIG_PROPERTIES"
  echo "Config sdk test address done";
}

packPerf(){
  echo "Config sdk perf address";
  sed -i "" "s#^ENV=.*#ENV=PERF#g" "$CONFIG_PROPERTIES"
  echo "Config sdk perf address done";
}

showUsage(){
  echo "must input build params:"
  echo "online  pack online evn"
  echo "test    pack test evn"
  exit 1;
}

updateBuildTime(){
  current_time=$(date "+%Y-%m-%d %H:%M:%S")
  echo "$current_time"
  sed -i "" '$d' "$CONFIG_PROPERTIES"
  echo "time=$current_time" >>"$CONFIG_PROPERTIES"
}

if [ "$ENV" == "online" ]; then
  packOnline
elif [ "$ENV" == "test" ]; then
  packTest
elif [ "$ENV" == "perf" ]; then
  packPerf
else
  packTest
fi

updateBuildTime
