# Copyright (c) 2022 NetEase, Inc. All rights reserved.
# Use of this source code is governed by a MIT license that can be
# found in the LICENSE file.

# 设置错误时退出和关闭命令显示
set -e
set +x

echo "Build ios start"
# 生成时间戳用于文件名
now=$(date +"%Y%m%d%H%M")

# 参数检查
if [ $# -lt 5 ]; then
    echo "错误: 参数不足"
    echo "用法: $0 <project_path> <archive_root_path> <archive_director_name> <archive_name> <ios_distribute_platform>"
    exit 1
fi

# 解析参数
project_path="$1"
archive_root_path="$2"
archive_director_name="$3"
archive_name="$4"
ios_distribute_platform="$5"

# 根据平台设置导出方法
if [ -z "$ios_distribute_platform" ]; then
  # 未指定平台，不出产物
  export_method=""
else
  export_method="$ios_distribute_platform"
fi

echo "======================================"
echo "project_path = ${project_path}"
echo "archive_root_path = ${archive_root_path}"
echo "archive_director_name = ${archive_director_name}"
echo "archive_name = ${archive_name}"
echo "export_method = ${export_method}"
echo "======================================"

# 清理Podfile.lock文件
echo "删除 podfile.lock $project_path/ios/Podfile.lock"
pwd
if [[ -f "$project_path/ios/Podfile.lock" ]]; then
  rm "$project_path/ios/Podfile.lock"
fi

echo "删除 nim_core_v2下的podfile.lock"
if [[ -f "$project_path/../nim_core_v2/example/ios/Podfile.lock" ]]; then
  rm "$project_path/../nim_core_v2/example/ios/Podfile.lock"
fi

# 定义路径变量
iosFilePath="$(pwd)/build/ios"
filePath="$(pwd)/build/ios/iphoneos/Runner.app"

# 清理并构建Flutter项目
echo "执行Flutter清理和更新依赖..."
fvm flutter clean
fvm flutter pub upgrade

# 更新iOS依赖
echo "更新CocoaPods依赖..."
cd "$(pwd)/ios"
pod update
cd ..

# 构建Flutter iOS项目
echo "构建Flutter iOS项目..."
fvm flutter build ios --target=integration_test/main_test.dart --profile

# 检查构建是否成功
if [ ! -d "$filePath" ]; then
  echo "错误: 构建失败，找不到Runner.app文件"
  exit 1
fi

# 打包Payload目录
echo "打包Payload目录..."
# 创建必要的目录结构
rm -rf "$iosFilePath/Payload"
mkdir -p "$iosFilePath/Payload"
mv "$filePath" "$iosFilePath/Payload/Runner.app"
cd "$iosFilePath"
zip -r "Payload.zip" "Payload"
cd ../..
echo "打包Payload目录 end..."
pwd
# 设置项目和输出路径
workspace_path="${project_path}/ios/Runner.xcodeproj"

# 创建输出目录结构
echo "准备输出目录..."
rm -rf "${archive_root_path}/ios/"
rm -rf "${project_path}/outputs/symbol/ios"
mkdir -p "${archive_root_path}/ios/${archive_director_name}"
mkdir -p "${project_path}/outputs/symbol/ios"

# 定义关键路径变量
output_path_app="${archive_root_path}/ios/${archive_director_name}"
output_path_symbol="${project_path}/outputs/symbol/ios"
archive_path="$output_path_symbol/nim_core_v2_${export_method}_${now}.xcarchive"
archive_zip_path="$output_path_app/nim_core_v2_${export_method}_${now}.xcarchive.zip"
ipa_name="${archive_name}.ipa"
ipa_path="${output_path_app}/${ipa_name}"

# 重命名Payload.zip为IPA文件
echo "生成IPA文件..."
cp -r "$iosFilePath/Payload.zip" "$ipa_path"
mv "$iosFilePath/Payload.zip" "$archive_zip_path"

# 输出路径信息
echo "===================================== "
echo "workspace path: ${workspace_path}"
echo "archive path: ${archive_path}"
echo "archive zip path: ${archive_zip_path}"
echo "output path: ${output_path_app}"
echo "ipa path: ${ipa_path}"
echo "===================================== "

# 决定是否需要归档
with_archive=true
if [[ -z ${ios_distribute_platform} ]]; then
  with_archive=false
fi


# 根据导出方法执行不同的Fastlane命令
# 打包签名是Jenkins ruby报错，暂时不需要注销

# 安装fastlane依赖
#echo "安装Fastlane依赖..."
#git clone ssh://git@g.hz.netease.com:22222/yunxin-app/tools.git build_tools
#ls
#if [ -f "./build_tools/common/ios/Gemfile" ]; then
#  cp ./build_tools/common/ios/Gemfile Gemfile && bundle install
#else
#  echo "警告: Gemfile文件不存在，跳过bundle install"
#fi
#if [[ ${export_method} == "enterprise" ]]; then
#  echo "执行企业版构建..."
#  bundle exec fastlane build_enterprise archive_path:${archive_path} output_directory:${output_path_app} output_name:${ipa_name} with_archive:${with_archive}
#elif [[ ${export_method} == "app-store" ]]; then
#  echo "执行App Store构建..."
#  bundle exec fastlane build_appstore archive_path:${archive_path} output_directory:${output_path_app} output_name:${ipa_name} with_archive:true
#  echo "上传到TestFlight..."
#  bundle exec fastlane upload_testflight ipa_path:${ipa_path}
#fi

# 压缩归档文件（如果需要）
if [[ "${with_archive}" == true ]]; then
  echo "压缩归档文件..."
  # 确保archive_path文件存在再尝试压缩
  if [ -d "$archive_path" ]; then
    zip -r "$archive_zip_path" "$archive_path"
    rm -rf "${project_path}/outputs/symbol"
  else
    echo "警告: 归档文件 ${archive_path} 不存在，跳过压缩"
  fi
fi

echo "Build ios done"

set +e
